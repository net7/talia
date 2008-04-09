# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register "application/rdf+xml", :rdf

# The are used for serving "static" widget content by mime type
Mime::Type.register "image/gif", :gif, [], %w( gif )
Mime::Type.register "image/jpeg", :jpeg, [], %w( jpeg jpg jpe jfif pjpeg pjp )
Mime::Type.register "image/png", :png, [], %w( png )
Mime::Type.register "image/tiff", :tiff, [], %w( tiff tif )
Mime::Type.register "image/bmp", :bmp, [], %w( bmp )
Mime::Type.register "video/isivideo", :isivideo, [], %w( fvi )
Mime::Type.register "video/mpeg", :mpeg, [], %w( mpeg mpg mpe mpv vbs mpegv )
Mime::Type.register "video/x-mpeg2", :xmpeg2, [], %w( mpv2 mp2v )
Mime::Type.register "video/msvideo", :msvideo, [], %w( avi )
Mime::Type.register "video/quicktime", :quicktime, [], %w( qt mov moov )
Mime::Type.register "video/vivo", :vivo, [], %w( viv vivo )
Mime::Type.register "video/wavelet", :wavelet, [], %w( wv )
Mime::Type.register "video/x-sgi-movie", :xsgimovie, [], %w( movie )