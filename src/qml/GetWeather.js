var Ctemperature=0;
var Ftemperature=0;

function getWeather() {
    var xmlhttp = new XMLHttpRequest();
    var url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%2091888417&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var response = JSON.parse(xmlhttp.responseText);
            temperature= Math.round((response.query.results.channel.item.condition.temp-32)/1.8)
            Ftemperature= Math.round(response.query.results.channel.item.condition.temp)
            Ctemperature= temperature
            var weatherSource= response.query.results.channel.item.description
            weatherTextString= response.query.results.channel.item.forecast[0].text

            // xu li weather icon source
            var begin= weatherSource.indexOf('http://')
            var end= weatherSource.indexOf('.gif')
            weatherIconSource= weatherSource.substring(begin, end+4)


            t1Text= response.query.results.channel.item.forecast[1].day +", "
            t1Text+= response.query.results.channel.item.forecast[1].date +"\n"
            t1Text+= response.query.results.channel.item.forecast[1].text +": "
            t1Text+= Math.round((response.query.results.channel.item.forecast[1].low-32)/1.8) +"~" +Math.round((response.query.results.channel.item.forecast[1].high-32)/1.8) +"°C";

            t2Text= response.query.results.channel.item.forecast[2].day +", "
            t2Text+= response.query.results.channel.item.forecast[2].date +"\n"
            t2Text+= response.query.results.channel.item.forecast[2].text +": "
            t2Text+= Math.round((response.query.results.channel.item.forecast[2].low-32)/1.8) +"~" +Math.round((response.query.results.channel.item.forecast[2].high-32)/1.8) +"°C";

            t3Text= response.query.results.channel.item.forecast[3].day +", "
            t3Text+= response.query.results.channel.item.forecast[3].date +"\n"
            t3Text+= response.query.results.channel.item.forecast[3].text +": "
            t3Text+= Math.round((response.query.results.channel.item.forecast[3].low-32)/1.8) +"~" +Math.round((response.query.results.channel.item.forecast[3].high-32)/1.8) +"°C";

            t4Text= response.query.results.channel.item.forecast[4].day +", "
            t4Text+= response.query.results.channel.item.forecast[4].date +"\n"
            t4Text+= response.query.results.channel.item.forecast[4].text +": "
            t4Text+= Math.round((response.query.results.channel.item.forecast[4].low-32)/1.8) +"~" +Math.round((response.query.results.channel.item.forecast[4].high-32)/1.8) +"°C";
        }
    }
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
}
