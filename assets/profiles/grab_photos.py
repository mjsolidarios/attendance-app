import urllib2
from PIL import Image, ImageOps, ImageDraw
import ssl
import os

# Download the user's facebook image
def download(id):
	url = "https://graph.facebook.com/"+id+"/picture?height=200&width=200"
	# evil - bypass ssl certification
	ctx = ssl.create_default_context()
	ctx.check_hostname = False
	ctx.verify_mode = ssl.CERT_NONE
	file_name = id+".jpg"
	u = urllib2.urlopen(url,context=ctx)
	# create file
	f = open(file_name, 'wb')
	meta = u.info()
	file_size = int(meta.getheaders("Content-Length")[0])
	print "Downloading profile picture: %s Bytes: %s" % (file_name, file_size)

	file_size_dl = 0
	block_sz = 8192
	while True:
	    buffer = u.read(block_sz)
	    if not buffer:
	        break

	    file_size_dl += len(buffer)
	    f.write(buffer)
	    status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
	    status = status + chr(8)*(len(status)+1)
	    print status,

	f.close()

# make the image rounded using crop and save it as PNG
def crop(file_name):
	f = file_name+".jpg"
	im = Image.open(f)
	bigsize = (im.size[0] * 3, im.size[1] * 3)
	mask = Image.new('L', bigsize, 0)
	draw = ImageDraw.Draw(mask) 
	draw.ellipse((0, 0) + bigsize, fill=255)
	mask = mask.resize(im.size, Image.ANTIALIAS)
	im.putalpha(mask)
	output = ImageOps.fit(im, mask.size, centering=(0.5, 0.5))
	output.putalpha(mask)
	o = file_name+".png"	
	output.save(o)
	os.remove(f)

fbids = open('fbids.txt','r')

for line in fbids:
	l = str(line.rstrip())
	download(l)
	crop(l)
