<html>
<head>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
</head>
<body>
<a href="uploads">uploads</a>

<?php

if (!isset($_FILES['upfile'])) {

?>
<form action="upload_file.php" method="post"
enctype="multipart/form-data">
<label for="file">Filename:</label>
<input type="file" name="upfile" id="upfile" /> 
<br />
<select name="subdir">
<?php
    $dir = '.';
    $d = dir($dir);
    while (false !== ($entry = $d->read())) {
       if($entry!='.' && $entry!='..') {
           $subdir = $dir.'/'.$entry;
           if(is_dir($subdir)) {
               if($entry == 'uploads') {
                   echo "<option value=\"$entry\" selected=\"selected\">$entry</option>";
               } else {
                   echo "<option value=\"$entry\">$entry</option>";
               }
           }
       }
   }
   $d->close();
?>
</select>
<br />
<input type="submit" name="submit" value="Submit" />
</form>
<?php
} else { // line:10 if (!isset($_FILES['upfile']))

try {
   
    // Undefined | Multiple Files | $_FILES Corruption Attack
    // If this request falls under any of them, treat it invalid.
    if (
        !isset($_FILES['upfile']['error']) ||
        is_array($_FILES['upfile']['error'])
    ) {
        echo "upload file error: ";
        print_r($_FILES['upfile']['error']);
        //throw new RuntimeException('Invalid parameters.');
    }

    // Check $_FILES['upfile']['error'] value.
    switch ($_FILES['upfile']['error']) {
        case UPLOAD_ERR_OK:
            break;
        case UPLOAD_ERR_NO_FILE:
            throw new RuntimeException('No file sent.');
        case UPLOAD_ERR_INI_SIZE:
        case UPLOAD_ERR_FORM_SIZE:
            throw new RuntimeException('Exceeded filesize limit.');
        default:
            throw new RuntimeException('Unknown errors.');
    }

    // You should also check filesize here.
    if ($_FILES['upfile']['size'] > 1000000000) {
        throw new RuntimeException('Exceeded filesize limit.');
    }

    // DO NOT TRUST $_FILES['upfile']['mime'] VALUE !!
    // Check MIME Type by yourself.
    /*
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    if (false === $ext = array_search(
        $finfo->file($_FILES['upfile']['tmp_name']),
        array(
            'jpg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',d
        ),
        true
    )) {
        throw new RuntimeException('Invalid file format.');
    }
    */

    // You should name it uniquely.
    // DO NOT USE $_FILES['upfile']['name'] WITHOUT ANY VALIDATION !!
    // On this example, obtain safe unique name from its binary data.
    if (!move_uploaded_file(
        $_FILES['upfile']['tmp_name'],
        sprintf('./%s/%s',
            isset($_POST['subdir'])?$_POST['subdir']:'uploads',
            $_FILES['upfile']['name']
            //    sha1_file($_FILES['upfile']['tmp_name']),
            //    $ext
            )
    )) {
        throw new RuntimeException('Failed to move uploaded file.');
    }

    echo 'File is uploaded successfully.';

} catch (RuntimeException $e) {

    echo $e->getMessage();

}

?>
<meta http-equiv="refresh" content="2;url=upload_file.php">
<?php
} // line:21 if (!isset($_FILES['upfile'])) {} else
?>
</body>
</html>