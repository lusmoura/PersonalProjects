'''Simple gets an image and makes it smaller'''

import numpy as np
import cv2

def main():

	print("Type the name of the image:")
	name = input()
	print("Type the scale (%): ")
	scale = input()
	
	try:
		img = cv2.imread(name)
		
		width = int(img.shape[1] * int(scale) / 100)
		height = int(img.shape[0] * int(scale) / 100)
		
		resized = cv2.resize(img, (width, height), interpolation= cv2.INTER_AREA)
		cv2.imwrite('resized.jpg', resized)
	except:
		print("Something went wrong")

if __name__ == '__main__':
	main()