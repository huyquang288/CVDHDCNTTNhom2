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

        }
    }
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
}
