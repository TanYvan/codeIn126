function page_check(obj1,obj2){
    if ( /^[0-9]*[1-9][0-9]*$/.test(document.getElementById(obj1).value)  &&  /^[0-9]*[1-9][0-9]*$/.test(document.getElementById(obj2).value) )
    {
        return true;
    }else{
        alert('请正确输入数字！');
        return false;
    }
}

