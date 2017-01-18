<?php
$LDAP_Config = array(
        "ldap_server" => "ldap://example.com",
        "ldap_organization" => "",
        "ldap_root_dn" => "ou=people,dc=example,dc=com",
        "ldap_uid_field" => "cn",
        "ldap_bind_dn" => '',
        "ldap_bind_pswd" => '',
);
function GetConfigValue($cfgkey) {
    global $LDAP_Config;
    if (isset($LDAP_Config[$cfgkey])) {
        return $LDAP_Config[$cfgkey];
    }
    return '';
}

$ldapconn = false;
$user_dn = false; 

function ldap_authenticate_by_username( $c_username, $p_password ) {
    global $ldapconn, $user_dn;

    $t_ldap_organization = GetConfigValue('ldap_organization');
    $t_ldap_root_dn = GetConfigValue( 'ldap_root_dn' );

    $t_ldap_uid_field = GetConfigValue('ldap_uid_field');
    $t_search_filter = "(&$t_ldap_organization($t_ldap_uid_field=$c_username))";
    $t_search_attrs = array('mail','dn');

    # Bind
    //log_event( LOG_LDAP, "Binding to LDAP server" );
    $ldapconn = ldap_connect(GetConfigValue('ldap_server'));
    if ( $ldapconn === false ) {
        return false;
    }
    
    ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3);
    $ldaprdn = GetConfigValue('ldap_bind_dn');
    $ldappass = GetConfigValue('ldap_bind_pswd');
    if (strlen($ldaprdn) == 0) {
        $user_dn = "$t_ldap_uid_field=$c_username,$t_ldap_root_dn";
        // verify binding
        $ldapbind = ldap_bind($ldapconn, $user_dn, $p_password);
        return $ldapbind ? true : false;
    } else {
        $ldapbind = ldap_bind($ldapconn, $ldaprdn, $ldappass);
        // verify binding
        if ($ldapbind) {
            //echo "LDAP bind successful...";
        } else {
            //echo "LDAP bind failed...";
            return false;
        }
    
        # Search for the user id
        $t_sr = ldap_search( $ldapconn, $t_ldap_root_dn, $t_search_filter, $t_search_attrs );
        if ( $t_sr === false ) {
            ldap_unbind( $ldapconn );
            return false;
        }
    
        $t_info = ldap_get_entries( $ldapconn, $t_sr );
        if ( $t_info === false ) {
            ldap_free_result( $t_sr );
            ldap_unbind( $ldapconn );
            return false;
        }
    
        $t_authenticated = false;
    
        if ( $t_info['count'] > 0 ) {
            # Try to authenticate to each until we get a match
            for ( $i = 0; $i < $t_info['count']; $i++ ) {
                $t_dn = $t_info[$i]['dn'];
    
                # Attempt to bind with the DN and password
                if ( ldap_bind( $ldapconn, $t_dn, $p_password ) ) {
                    $t_authenticated = true;
                    $user_dn = $t_dn;
                    break;
                }
            }
        } else {
            return false;
        }
        
        ldap_free_result( $t_sr );
    }

    return $t_authenticated;
}

function ldap_update_passwd($newPassword) {
    global $ldapconn, $user_dn;
    
    $userdata["userPassword"] = $newPassword;
    $result = ldap_mod_replace($ldapconn, $user_dn, $userdata);
    return $result;
}

$name= isset($_POST['name'])? $_POST['name']:'';
$p1=isset($_POST['p1'])?$_POST['p1']:'';
$p2=isset($_POST['p2'])?$_POST['p2']:'';
$oldpass=isset($_POST['oldpass'])?$_POST['oldpass']:'';
$info="";

while(true)
{
 if( !empty($name))
 {
    if(ldap_authenticate_by_username($name, $oldpass)){
       //$info="密码验证成功";
    } else {
       $info="旧密码验证失败";
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

  if(ldap_update_passwd($p1))
   $info="密码修改成功";
  else
   $info="密码修改失败";
 }
 break;
}

?>
<html>
<head>

<title>修改密码</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
</head>

<style type="text/css">.t_input {background-color:#FFFFFF;width:139px;height:22px;font-family:Tahoma;}.t_text {background-color:#FFFFFF;font-family:新宋体,宋体,Tahoma;}</style>


<body>

 <?php if($info."a"!="a") { ?>
 <table align="center">
  <tr>
   <td align="center" class="t_text">
    <font size=4 color="#ff0000"><?php echo $info; ?> </font>
   </td>
  </tr>
 </table>
 <?php } ?>
 <form method="POST" enctype="multipart/form-data"  >
 <table align="center">
   <tr>
   <td align="center" class="t_text" colspan="2">
    修改密码
   </td>
  </tr>
  <tr>
   <td class="t_text">用户名</td>
   <td><input name="name" class="t_input" value=""></td>
  </tr>
  <tr>
   <td class="t_text">旧密码</td>
   <td><input type="password" name="oldpass" class="t_input" value=""></td>
  </tr>
  <tr>
   <td class="t_text">新密码</td>
   <td><input type="password" name="p1"class="t_input"></td>
  </tr>
  <tr>
   <td class="t_text">验证新密码</td>
   <td><input type="password" name="p2"class="t_input"></td>
  </tr>
  <tr>
   <td><a href=<?php echo '"http://'.$_SERVER["HTTP_HOST"].'/"'; ?>>回首页</a></td>
   <td><input type="submit" name="chgpasswd" value="修 改"></td>
  </tr>
 </table>
</form>
</body></html>
