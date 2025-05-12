<?php
//数据库连接类
//使用时调用此函数即可
function conndatabase($sql){
    $servername = "db";//数据库地址
    $db = "jsp";//指定数据库名
    $username = "jsp";//数据库用户
    $password = "Aa123456@";//数据库密码
    // 创建连接
    $conn = new mysqli($servername, $username, $password,$db);
    // 检测连接
    if ($conn->connect_error) {
        echo $conn->connect_error;//抛出异常
    } 
    else{
        $result = $conn->query($sql);
        return $result;//返回结果，查询需进一步处理
    }
    mysqli_close($conn);
} 
?>
