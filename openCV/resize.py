'''Simple gets an image and makes it smaller'''

import numpy as np
import cv2

def main():

	print("Type the name of the image:")
	name = input()

	try:
		img = cv2.imread(name)
		
		aux = 100.0 / img.shape[1]
		factor = (100, int(img.shape[0] * aux))
	
		resized = cv2.resize(img, factor, interpolation= cv2.INTER_AREA)
		cv2.imwrite('resized.jpg', resized)
	except:
		print("Something went wrong")

if __name__ == '__main__':
	main()