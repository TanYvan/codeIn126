/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

        var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        var s;
        (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
        (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
        (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
        (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
        (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
        //返回浏览器的类型
        if (Sys.ie) document.getElementById("navigator_type")=('IE');
        if (Sys.firefox) document.getElementById("navigator_type")=('Firefox');
        if (Sys.chrome) document.getElementById("navigator_type")=('Chrome');
        if (Sys.opera) document.getElementById("navigator_type")=('Opera');
        if (Sys.safari) document.getElementById("navigator_type")=('Safari');        
        
        //以下进行测试
//        if (Sys.ie) document.write('IE: ' + Sys.ie);
//        if (Sys.firefox) document.write('Firefox: ' + Sys.firefox);
//        if (Sys.chrome) document.write('Chrome: ' + Sys.chrome);
//        if (Sys.opera) document.write('Opera: ' + Sys.opera);
//        if (Sys.safari) document.write('Safari: ' + Sys.safari);
