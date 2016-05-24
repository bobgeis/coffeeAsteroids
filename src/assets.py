"""
This writes lists/dicts of assets to load to a .coffee file.

Consider rewriting this in coffeescript/node.

OR use a proper build tool :)
"""


import sys, glob, os
os.chdir("..")
path = os.path.abspath(os.curdir)

img_folders = ['ship','space','star']
snd_folders = []

def get_file_name(file):
	"get the name of the file"
	return file.split('/')[-1].split('.')[0]

def form_lines_for_folder(folder,files):
	"return a list of coffeescript lines"
	lines = []
	lines.append('A.'+folder+' = {}\n')
	for f in files:
		name = get_file_name(f)
		lines.append('A.'+folder+'.'+name+' = "'+f+'"\n')
	return lines

def find_lines_for_folder(topfold,folder,ext):
	"find and form lines for the files of interest"
	files = glob.glob('./asset/'+topfold+'/'+folder+'/*'+ext)
	lines = form_lines_for_folder(folder,files)
	return lines

def write_lines(file,topfold,folder,ext):
	"write the lines for the files in the asset folder of interest"
	lines = find_lines_for_folder(topfold,folder,ext)
	for l in lines:
		file.write(l)
		print l

def write_list(file,name,arglist):
	"write a list of strings to file"
	header = name+" = ["
	footer = "]\n"
	file.write(header)
	for l in arglist:
		file.write("'"+l+"',")
	file.write(footer)


def main():
	"run!"
	file = open('./src/assets.coffee','w+') 
	header = "A = {}\n_first.offer('assets',A)\n"
	file.write(header)
	write_list(file,"A.imgFolders",img_folders)
	write_list(file,"A.sndFolders",snd_folders)
	for folder in img_folders:
		write_lines(file,'img',folder,'.png')
	file.close()



if __name__ == '__main__':
	main()