<?php
$name= isset($_POST['name'])? $_POST['name']:'';
$p1=isset($_POST['p1'])?$_POST['p1']:'';
$p2=isset($_POST['p2'])?$_POST['p2']:'';
$oldpass=isset($_POST['oldpass'])?$_POST['oldpass']:'';
$authed_user=$name;//$_SERVER["PHP_AUTH_USER"];
//$authed_pass = $_SERVER["PHP_AUTH_PW"]; 
$info="";
$htpasswd="C:/xampp/apache/bin/htpasswd.exe";
$passfile="D:/Repositories/htpasswd";
//$info=apache_getenv("ServerName");

while(true)
{
 if( !empty($name))
 {
    $cmd=$htpasswd." -bmv ".$passfile." ".$authed_user." ".$oldpass;
    exec($cmd,$out_put,$ret);
    if(0==$ret){
       //$info="密码验证成功";
    } else {
       $info="旧密码验证失败,返回值".$ret;
       break;
    }


  if(empty($p1) || empty($p2))
  {
   $info="新密码不能为空";
   break;
  }
  if($p1!=$p2)
  {
   $info="新密码不相等";
   break;
  }
  $len=strlen($p1);
  if(6>$len)
  {
   $info="新密码长度不能小于6位";
   break;
  }

  
  $cmd=$htpasswd." -mb ".$passfile." ".$authed_user." ".$p1;
  exec($cmd,$out_put,$ret);
  if(0==$ret)
   $info="密码修改成功";
  else
   $info="密码修改失败,返回值".$ret;
  //virtual("/pass/refresh.php");
 }
 break;
}

?>
<HTML>
<HEAD>

<TITLE>修改SubVersion密码</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
</HEAD>

<style type="text/css">.t_input {background-color:#FFFFFF;width:139px;height:22px;font-family:Tahoma;}.t_text {background-color:#FFFFFF;font-family:新宋体,宋体,Tahoma;}</style>


<BODY>

 <?php if($info."a"!="a") { ?>
 <table align="center">
  <tr>
   <td align="center" class="t_text">
    <font size=4 color="#ff0000"><?php echo $info; ?> </font>
   </td>
  </tr>
 </table>
 
 <?php } ?>
 <table align="center">
  <tr>
   <td align="center" class="t_text">
    修改SubVersion密码
   </td>
  </tr>
 </table>
 <form method="POST" enctype="multipart/form-data"  >
 <br>
 <TABLE align="center">
  <TR>
   <TD class="t_text">用户名</TD>
   <TD><INPUT name="name" class="t_input" value=""></TD>
  </TR>
  <TR>
   <TD class="t_text">旧密码</TD>
   <TD><INPUT type="password" name="oldpass" class="t_input" value=""></TD>
  </TR>
  <TR>
   <TD class="t_text">新密码</TD>
   <TD><INPUT type="password" name="p1"class="t_input"></TD>
  </TR>
  <TR>
   <TD class="t_text">验证新密码</TD>
   <TD><INPUT type="password" name="p2"class="t_input"></TD>
  </TR>
 </TABLE>
 <br>
 <TABLE align="center">
  <TR>
   <td><a href=<?php echo '"http://'.$_SERVER["HTTP_HOST"].'/"'; ?>>回首页</a></td>
   <TD><input type="submit" name="chgpasswd" value="修 改">
   <input type="reset" value="重 置">
   
   </TD>
  </TR>
 </TABLE>
</form>
</BODY></HTML>
