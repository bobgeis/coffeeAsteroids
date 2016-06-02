"""
This writes a list of all .js files we need to load to a .coffee file.

Consider re-writing this in coffeescript using node.

OR use a proper build tool :)
"""



import sys, glob, os
os.chdir("..")
path = os.path.abspath(os.curdir)
prefix = "document.write('<script src="
suffix = "></script>')\n"
skiplist = ['first.js','scripts.js','last.js']

def in_skiplist(full_name):
	name = full_name.split('/')[-1]
	count = skiplist.count(name)
	return count > 0

def find_js():
	"js files are assumed to be in /js/"
	top = glob.glob('./js/*.js')
	middle = glob.glob('./js/*/*.js')
	bottom = glob.glob('./js/*/*/*.js')
	why = glob.glob('./js/*/*/*/*.js')
	files = top + middle + bottom + why
	files.reverse()
	return files


def main():
	"run!"
	commands = []
	files = find_js()
	for f in files:
		if not in_skiplist(f):
	 		commands.append(prefix + '"' + f[2:] + '"' + suffix)
	file = open('./src/scripts.coffee', 'w+') 
	# file.write('"test"')
	for c in commands:
		file.write(c)
		print c
	file.close()



if __name__ == '__main__':
	main()