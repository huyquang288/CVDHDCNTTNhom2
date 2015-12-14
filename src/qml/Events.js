var events= "2015-12-15>>10h30:Di gap thay//14h00:Bao cao bai tap||2015-12-16>>8h:Gap ong Hung";

function hasEvent(dat) {
    var datee= dat.getYear() +"-" +(dat.getMonth()+1) +"-" +dat.getDate()
    var spitDay= events.split('||');
    for (var i=0; i<spitDay.length; i++) {
        var ngay= spitDay[i];
        if (dat===ngay.split('>>', 1))  return true;
    }
    return false;
}

function getEvents (dat) {
    return true;
}

