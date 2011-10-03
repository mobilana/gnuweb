dnl @synopsis ACX_HTACCESS
dnl
dnl Generates a HTACCESS file
dnl 
dnl 
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_HTACCESS],[
   printf "
DirectoryIndex index.php
Options +FollowSymLinks
IndexIgnore */*
RewriteEngine On
RewriteBase /@webprefix@
RewriteRule ^.*/style/(.*)$ style/$\x31
RewriteRule ^.*/js/(.*)$    js/$\x31
RewriteRule ^.*/data/(.*)$  data/$\x31
RewriteRule ^.*/share/(.*)$ share/$\x31
RewriteCond %%{REQUEST_FILENAME} !-f
RewriteCond %%{REQUEST_FILENAME} !-d
RewriteRule . index.php

<FilesMatch \"\.(ico|pdf|flv|jpg|jpeg|png|gif|js|css|swf)$\">
Header set Cache-Control \"max-age=290304000, public\"
</FilesMatch>

Header unset ETag
FileETag None
" > htaccess.in

])
