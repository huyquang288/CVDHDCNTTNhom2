function getDay() {
    switch (now.getDay()) {
        case 1: {
            dayText= "Thứ 2 "
            break;
        }
        case 2: {
            dayText= "Thứ 3 "
            break;
        }
        case 3: {
            dayText= "Thứ 4 "
            break;
        }
        case 4: {
            dayText= "Thứ 5 "
            break;
        }
        case 5: {
            dayText= "Thứ 6 "
            break;
        }
        case 6: {
            dayText= "Thứ 7 "
            break;
        }
        case 0: {
            dayText= "Chủ nhật "
            break;
        }
    }
    dayText+= now.getDate() +"/" +(now.getMonth()+1) +"/" +now.getFullYear()
}

