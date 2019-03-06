'''	Extracs blue objects from images. To use with defferent colors
	it's necessary to change the lowBlue and upBlue values to
	the respective lower and upper values of the color you want.
'''

import numpy as np
from cv2 import *

def main():
	print("Type the name of the image:")
	name = input()

	try:
		# reads image and converts from RGB to HSV
		img = imread(name, IMREAD_COLOR)
		imgHSV = cvtColor(img, COLOR_BGR2HSV)

		# gets the min and max values for blues
		lowBlue = np.array([110, 50, 50])
		upBlue = np.array([130, 255, 255])

		# threshold the image for a range of blue
		# and extrats the blue object with an 'and'
		mask = cv2.inRange(imgHSV, lowBlue, upBlue)
		final = cv2.bitwise_and(img, img, mask= mask)

		# shows the images
		cv2.imshow('original image', img)
		cv2.imshow('hsv image', imgHSV)
		cv2.imshow('mask', mask)
		cv2.imshow('edited image', final)
		cv2.imwrite('blue.png', final)
		cv2.waitKey(0)
		cv2.destroyAllWindows()
	except:
		print("Something went wrong")

if __name__ == '__main__':
	main()