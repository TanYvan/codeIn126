function page_check()
{
    if ( /^[1-9]d*$/.test(document.getElementById('page').value)  &&  /^[1-9]d*$/.test(document.getElementById('page_lines').value) )
    {
        return true;
    }
    else
    {
        alert('翻页信息非法！');
        return false;
    }
}  

function to_excel(obj) {
    //obj为某个table  document.getElementById，copy到excel
    window.clipboardData.setData("Text",obj.outerHTML);   //document.all('tt')
    try
    {
        var ExApp = new ActiveXObject("Excel.Application")
        var ExWBk = ExApp.workbooks.add()
        var ExWSh = ExWBk.worksheets(1)
        ExApp.DisplayAlerts = false
        ExApp.visible = true
    }
    catch(e)
    {
        alert("您的电脑没有安装Microsoft Excel软件！")
        return false
    }
    ExWBk.worksheets(1).Paste;
    window.clipboardData.setData("Text","")
}

function   to_word() {
    //取整个页面,copy到word
    document.execCommand("SelectAll");
    document.execCommand("Copy");
    try
    {
        var   WordApp=new   ActiveXObject("Word.Application");
        WordApp.Application.Visible=true;
        var   Doc=WordApp.Documents.Add();
        Doc.Activate();
        Doc.Content.Paste();  
        WordApp.visible = true
    }
    catch(e)
    {
        alert("您的电脑没有安装Microsoft Word软件！")
        return false
    }
    Doc.Content.Paste();
}

function   to_word_2() {
    //取整个页面,copy到word,设置word为横向
    document.execCommand("SelectAll");
    document.execCommand("Copy");
    try
    {
        var   WordApp=new   ActiveXObject("Word.Application");
        WordApp.Application.Visible=true;
        var   Doc=WordApp.Documents.Add();
        Doc.Activate();
        Doc.Content.Paste();  
        WordApp.ActiveDocument.PageSetup.Orientation = 1 //设置word为横向
        WordApp.visible = true
    }
    catch(e)
    {
        alert("您的电脑没有安装Microsoft Word软件！")
        return false
    }
    Doc.Content.Paste();
}

function getcondi()
{ //选择申请人
    var chec = document.getElementsByName("che_p");
    var a='';
    for(i=0; i<chec.length; i++)
    {
        if (chec[i].checked == true)
            a=a+chec[i].value+'、';
    }

    aa=a.substr(0, a.length -1 )
    var c = document.getElementById("condi");
    c.value=aa;

    //选择被申请人
    var chet = document.getElementsByName("che_t");
    var b=''
    for(i=0; i<chet.length; i++)
    {
        if (chet[i].checked == true)
            b=b+chet[i].value+'、';
    }
    bb=b.substr(0, b.length -1 )
    var c2 = document.getElementById("condi");
    c2.value=bb;
    //不能同时选择
    if(aa!='' && bb!=''){
        alert("申请人和被申请人不能同时选择！");
        return false;
    }
    if(aa!='' && bb==''){
        var c = document.getElementById("condi");
        c.value='a'+aa;
    }else if(aa=='' && bb!=''){
        var c2 = document.getElementById("condi");
        c2.value='b'+bb;
    }
    return true;
}

