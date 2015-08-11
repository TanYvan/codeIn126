/*
 * 用于客户端排序的函数。
 * 这些函数都是用于对指定table对象的排序，其参数列表如下：
 * table：待排序的table对象
 * nColNum：待排序的table对象中的待排序的行号，从0开始
 * strDataType：待排序的table对象中的待排序列的数据类型，有int、float、string。根据需要可增加
 * nSortOrder：排序方式。若>0，降序，否则升序。
 *
 * created by 卢罡
 * 2009.6.18
 */

//Swap是用于交换指定table对象的指定两行i和j
function Swap(table,i,j){
    if(i<0 || j>table.rows.length-1 || i==j) return;
    if(i<j){
        table.moveRow(i,j);
        table.moveRow(j-1,i);
    }
    else{
        table.moveRow(i,j);
        table.moveRow(j+1,i);
    }
}

//快速排序
function QuickSort(table,nColNum,strDataType,nSortOrder){
    
    function doSort(table,s,e){
        if(s<e){
            var pos=partition(table,nColNum,strDataType,nSortOrder,s,e);
            doSort(table,s,pos-1);
            doSort(table,pos+1,e);
        }
    }

    //用于快速排序的划分函数
    function partition(table,nColNum,strDataType,nSortOrder,st,en){
        var temp=""
        if (strDataType=="int_percent"){
             a=(table.rows[en].cells[nColNum].childNodes[0].data).indexOf("/");
            if (a>0){
              temp=(table.rows[en].cells[nColNum].childNodes[0].data).substr(0,a-1);
            }
        }else{ temp=table.rows[en].cells[nColNum].childNodes[0].data;}

        var i=st-1;

        switch(strDataType){
            case "int":
                if(nSortOrder>0){  //desc
                    for(j = st; j < en; j++) {
                        if (parseInt(table.rows[j].cells[nColNum].childNodes[0].data)<
                            parseInt(temp)) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
                    Swap(table, ++i, en);
                    return i;
                }
                else{
                    for(j = st; j < en; j++) {
                        if (parseInt(table.rows[j].cells[nColNum].childNodes[0].data)>
                            parseInt(temp)) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
                    Swap(table, ++i, en);
                    return i;
                }
                break;
            case "float":
                if(nSortOrder>0){  //desc
                    for(j = st; j < en; j++) {
                        if (parseFloat(table.rows[j].cells[nColNum].childNodes[0].data)<
                            parseFloat(temp)) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
                    Swap(table, ++i, en);
                    return i;
                }
                else{
                    for(j = st; j < en; j++) {
                        if (parseFloat(table.rows[j].cells[nColNum].childNodes[0].data)>
                            parseFloat(temp)) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
                    Swap(table, ++i, en);
                    return i;
                }
                break;
                case "int_percent":
                  if(nSortOrder>0){  //desc
                    for(j = st; j < en; j++) {
                      a=(table.rows[j].cells[nColNum].childNodes[0].data).indexOf("/");
                    if (a>0){
                    aa=(table.rows[j].cells[nColNum].childNodes[0].data).substr(0,a-1);
                        if (parseFloat(aa)<parseFloat(temp)) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
            }
              Swap(table, ++i, en);
                    return i;
                }
                else{
                    for(j = st; j < en; j++) {
                        a=(table.rows[j].cells[nColNum].childNodes[0].data).indexOf("/");
                    if (a>0){
                    aa=(table.rows[j].cells[nColNum].childNodes[0].data).substr(0,a-1);
                        if (parseFloat(aa)>parseFloat(temp)) {
                            i++;
                            Swap(table, i, j);
                        }
                    } }
                  Swap(table, ++i, en);
                    return i;
                }
                break;

            case "string":
            default:{
                if(nSortOrder>0){  //desc
                    for(j = st; j < en; j++) {
                        if (table.rows[j].cells[nColNum].childNodes[0].data.toString()<
                            temp.toString()) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
                    Swap(table, ++i, en);
                    return i;
                }
                else{
                    for(j = st; j < en; j++) {
                        if (table.rows[j].cells[nColNum].childNodes[0].data.toString()>
                            temp.toString()) {
                            i++;
                            Swap(table, i, j);
                        }
                    }
                    Swap(table, ++i, en);
                    return i;
                }
            }
        }//switch
    }

    doSort(table,1,table.rows.length-1);
}

//冒泡排序，可用于数据量较少的排序
function BubbleSort(table,nColNum,strDataType,nSortOrder){ //冒泡排序
    var length=table.rows.length;
    for(var i=1;i<length;i++){  //由于表头还有一行，故i从1开始
        var exchanged=false;
        for(var j=length-1;j>i;j--){
            switch(strDataType){
                case "int":
                    if(nSortOrder>0){  //desc
                        if(parseInt(table.rows[j].cells[nColNum].childNodes[0].data) >
                            parseInt(table.rows[j-1].cells[nColNum].childNodes[0].data)){
                            Swap(table,j,j-1);
                            exchanged=true;
                        }
                    }
                    else{
                        if(parseInt(table.rows[j].cells[nColNum].childNodes[0].data) <
                            parseInt(table.rows[j-1].cells[nColNum].childNodes[0].data)){
                            Swap(table,j,j-1);
                            exchanged=true;
                        }
                    }
                    break;
                case "float":
                    if(nSortOrder>0){  //desc
                        if(parseFloat(table.rows[j].cells[nColNum].childNodes[0].data) >
                            parseFloat(table.rows[j-1].cells[nColNum].childNodes[0].data)){
                            Swap(table,j,j-1);
                            exchanged=true;
                        }
                    }
                    else{
                        if(parseFloat(table.rows[j].cells[nColNum].childNodes[0].data) <
                            parseFloat(table.rows[j-1].cells[nColNum].childNodes[0].data)){
                            Swap(table,j,j-1);
                            exchanged=true;
                        }
                    }
                    break;
                case "string":
                default:
                    if(nSortOrder>0){  //desc
                        if(table.rows[j].cells[nColNum].childNodes[0].data.toString() >
                            table.rows[j-1].cells[nColNum].childNodes[0].data.toString()){
                            Swap(table,j,j-1);
                            exchanged=true;
                        }
                    }
                    else{
                        if(table.rows[j].cells[nColNum].childNodes[0].data.toString() <
                            table.rows[j-1].cells[nColNum].childNodes[0].data.toString()){
                            Swap(table,j,j-1);
                            exchanged=true;
                        }
                    }
            } //switch
        } //for j
        if (!exchanged) break;
    } //for i
}