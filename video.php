<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Videos</title>
<style>
*{
  margin: 0;
  padding: 0;
}
ul {
  list-style: none outside none;
  padding: 10px;
//  background: green;
//  text-align: center;
}
ul.withcover li {
  display: inline-block;
  *display: inline;
  zoom: 1;
//  background: orange;
  padding: 5px;
}
a.playing {
text-decoration:none;
background-color:GreenYellow;
}
h1:playing
{
  content:url(loading_medium.gif);
}
a.waiting {
text-decoration:underline;
//background-color:rgb(255,255,0);
}

</style>
<link href="video-js-6.2.8/video-js.css" rel="stylesheet">
</head>
<body>
<?php
if (isset($_GET['list'])) {
    $directory = '/mnt/array1/share/video/'.$_GET['list'];
    $webdir = '/video/'.$_GET['list'];
    chdir($directory);
    //$scanned_directory = array_diff(scandir($directory), array('..', '.'));
    $filenames_array = array();
    $fullfilenames_array = array();
    foreach (array('*.flv','*.f4v','*.mp4') as $cls) {
        $scanned_directory =  glob($cls);
        //print_r($scanned_directory);
        foreach ($scanned_directory as $filename) {
            $fullfilenames_array[] = $webdir.'/'.$filename;
            $filenames_array[] = $filename;
        }
    }
    if (count($filenames_array)) {
        $startkey = array_search($_GET['start'], $filenames_array);
        $filenames = implode("|",array_slice($fullfilenames_array,$startkey));
?>
    <video id="video" class="video-js vjs-default-skin" controls data-setup="" autoplay="autoplay" ></video><!--width="640" height="480" -->
    <h1></h1>
    <button type="button" data-action="prev" id="btn-prev">Previous</button>
    <button type="button" data-action="next" id="btn-next">Next</button>
    <script src="video-js-6.2.8/video.js"></script>
    <script src="node_modules/flv.js/dist/flv.js"></script>
    <script src="node_modules/videojs-flvjs/dist/videojs-flvjs.js"></script>
    <script src="video-js-playlist/videojs-playlist.js"></script>
    <script language="javascript">
    var videos = [
<?php
function genItem($fn){
  return '{sources:[{src:"/video/'.$_GET['list'].'/'.$fn.'",type:"video/'.substr($fn,-3).'"}]}';
}
echo implode(',',array_map('genItem',$filenames_array));
?>
];
    var player = videojs('video', {techOrder: ['html5', 'flvjs']});
    player.on('playlistitem', function() {
      console.log('listid'+player.playlist.currentItem());
      setTimeout(function(){
          //console.dir(document.getElementsByClassName('playing')[0]);
          var pl = document.getElementsByClassName('playing');
          for (var i in pl) {
            pl[i].className='waiting';
          }
          document.getElementById('listid'+player.playlist.currentItem()).className='playing';
          //console.dir(document.getElementsByClassName('playing')[0]);
      },100);
    });
    player.playlist(videos);
    player.playlist.repeat(true);
    player.playlist.autoadvance(0);
    document.getElementById("btn-prev").onclick=function(){player.playlist.previous();}
    document.getElementById("btn-next").onclick=function(){player.playlist.next();}
    player.on('playlistchange', function() {
      player.playlist();
    });

    </script>

    <div><a href="/video/">视频</a></div>
    <div>
    <ul>
<?php
foreach ($filenames_array as $indexkey => $filename) {
?>
<li>
<?php
    echo '<a class="waiting" id="listid'.$indexkey.'" onclick="player.playlist.currentItem('.$indexkey.');" href="javascript:;">'.$filename.'</a>';
?>
</li>
<?php
}
?>
</ul>
    </div>
<?php
    } // endof if (count($filenames_array))
    else {
?>
    <div><a href="index.php">没有可播放视频，自动跳转回去。。。</a></div>
    <meta http-equiv="refresh" content="0; url=index.php">
<?php
    }
} else { // if (isset($_GET['list']))
    $directory = '/mnt/array1/share/video/';
    $handle = opendir($directory);
    $list_withcover = array();
    $list_withoutcover = array();
    $skiped = array('.','..','video-js-6.2.8','video-js-playlist','node_modules');
    while($file= readdir($handle)){
        if(!in_array($file, $skiped)){
            if(is_dir($directory."/".$file)) {
                if (file_exists($directory.'/'.$file.'/cover.jpg')) {
                    $list_withcover[] = $file;
                } else {
                    $list_withoutcover[] = $file;
                }
                
            }
        }
    }
    echo "<div><ul class=\"withcover\">";
    foreach ($list_withcover as $f) {
        echo "<li><a href=\"/video/index.php?list=$f\"><img src=\"/video/$f/cover.jpg\" height=\"200\" width=\"150\" ></a></li>";
    }
    echo "</ul></div>";
    echo "<div><ul>";
    foreach ($list_withoutcover as $f) {
        echo "<li><a href=\"/video/index.php?list=$f\">$f</a></li>";
    }
    echo "</ul></div>";
}

?>
</body>
</html>