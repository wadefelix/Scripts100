<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <meta http-equiv="content-type" content="text/html; charset=gb2312">
  <meta name="generator" content="PSPad editor, www.pspad.com">
  <title>视频下载</title>
<script type="text/javascript">

  function addtask()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    //alert(xmlhttp.responseText);
    document.getElementById('result').innerHTML= "任务添加结果:"+xmlhttp.responseText;
    }
  }
var urlpostcont = document.getElementById("addtaskbtn").getAttribute("data-cont");
xmlhttp.open("post","http://192.168.1.4:6800/jsonrpc",true);
xmlhttp.setRequestHeader("Content-type","application/json");
xmlhttp.setRequestHeader("Accept-Encoding","deflate");
xmlhttp.setRequestHeader("Accept","application/json");
xmlhttp.send(urlpostcont);
}
</script>
  </head>
  <body>


      <form name="mainform" action="flvcd.php" method="get" onsubmit="">
      <input type="hidden" name="format" />
      <input name="kw" type="text" id="kw" size="45" style="font-size:18px;height:20px;padding-top:2px;" value=""/>
      <input type="submit" value="开始GO!" style="height:28px;font-size: 12px;color:#FFFFFF; background: #7094B8; border-width: thin thin thin thin; border-color: #CCCCFF #CCCCCC #CCCCCC #CCCCFF" />
      </form>

<?php
// 使用flvcd.com的服务解析视频地址，最好能直接发送给aria下载

if (isset($_GET['kw'])) {
  $flvcdurl = "http://www.flvcd.com/parse.php?kw=".urlencode($_GET['kw'])."&flag=one&format=high"; // normal high super real
  echo '<p><a href="'.$flvcdurl.'">硕鼠网站解析页面</a></p>';

        $headers = array( 
            "Accept: text/html, application/xhtml+xml, image/jxr, */*",
            "Connection: Keep-Alive",
            "Host: www.flvcd.com",
            "Accept-Encoding: deflate",// gzip
            "Accept-Language: zh-Hans-CN, zh-Hans; q=0.8, en-US; q=0.5, en; q=0.3",
            "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586"
        ); 

/// --------
$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, $flvcdurl); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); 

$page = curl_exec($ch);
curl_close($ch);
  $pattern = '@<script type="text/javascript">var showclip = 1;var clipurl = "(http://[^"]*)";var cliptitle = "([^"]*)";</script>@i';
  //$pattern = iconv('UTF-8','GB2312',$pattern);
  preg_match($pattern, $page , $matches);
  $dlurl = $matches[1];
  $title = $matches[2];
  $jsonreq = Array('jsonrpc'=>'2.0',
                 'id'=>'qwer',
                  'method'=>'aria2.addUri',
                  'params'=> array( array($dlurl),Array("out"=> "".iconv('GB2312','UTF-8',$title))));
  $jsonreqstr = json_encode($jsonreq);
?>
<div>
<p>title: <?php echo $title;?></p>
<p><input id="addtaskbtn" type="button" class="tagbtn" value="添加下载任务到aria2" onclick="addtask()" data-cont='<?php echo $jsonreqstr;?>' /></p>
<p id="result"></p>
<?php
}
?>
  </body>
</html>


