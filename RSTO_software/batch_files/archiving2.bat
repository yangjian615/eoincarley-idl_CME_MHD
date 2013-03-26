C:

cd C:\Inetpub\wwwroot\callisto\data\

mkdir %Date:~-4,4%%Date:~-7,2%%Date:~-10,2%
cd %Date:~-4,4%%Date:~-7,2%%Date:~-10,2%
mkdir fts\high_freq
mkdir fts\low_freq
mkdir fts\mid_freq
mkdir png\high_freq
mkdir png\low_freq
mkdir png\mid_freq

cd C:\Inetpub\wwwroot\callisto\data\realtime\fts\high_freq
move *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\fts\high_freq

cd C:\Inetpub\wwwroot\callisto\data\realtime\fts\low_freq
move *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\fts\low_freq

cd C:\Inetpub\wwwroot\callisto\data\realtime\fts\mid_freq
move *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\fts\mid_freq



cd C:\Inetpub\wwwroot\callisto\data\realtime\png\high_freq
copy index.php C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\high_freq
move *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\high_freq

cd C:\Inetpub\wwwroot\callisto\data\realtime\png\low_freq
copy index.php C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\low_freq
move *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\low_freq

cd C:\Inetpub\wwwroot\callisto\data\realtime\png\mid_freq
move *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\mid_freq


cd C:\Documents and Settings\Joe\Desktop\Data_new_archive
mkdir %Date:~-4,4%
cd %Date:~-4,4%
mkdir %Date:~-7,2%
cd %Date:~-7,2%
mkdir %Date:~-10,2%
cd %Date:~-10,2%
mkdir fts
mkdir png

cd C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\fts\high_freq
copy *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Docume~1\Joe\Desktop\Data_new_archive\%Date:~-4,4%\%Date:~-7,2%\%Date:~-10,2%\fts

cd C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\fts\low_freq
copy *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Docume~1\Joe\Desktop\Data_new_archive\%Date:~-4,4%\%Date:~-7,2%\%Date:~-10,2%\fts

cd C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\fts\mid_freq
copy *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Docume~1\Joe\Desktop\Data_new_archive\%Date:~-4,4%\%Date:~-7,2%\%Date:~-10,2%\fts



cd C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\high_freq
copy *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Docume~1\Joe\Desktop\Data_new_archive\%Date:~-4,4%\%Date:~-7,2%\%Date:~-10,2%\png

cd C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\low_freq
copy *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Docume~1\Joe\Desktop\Data_new_archive\%Date:~-4,4%\%Date:~-7,2%\%Date:~-10,2%\png

cd C:\Inetpub\wwwroot\callisto\data\%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%\png\mid_freq
copy *%Date:~-4,4%%Date:~-7,2%%Date:~-10,2%* C:\Docume~1\Joe\Desktop\Data_new_archive\%Date:~-4,4%\%Date:~-7,2%\%Date:~-10,2%\png


