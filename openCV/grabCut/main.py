'''	Grab cut is an algorithm that can be used to remove an image background.
	
	- Using a Gaussian Mixture Model (GMM), the algorithm labels the pixels depending on 
	its relation with other pixels in terms of color satistics, they can be (0)background, 
	(1)foreground or (2)probable background/foreground.
	- Each pixel is now trated as a node in a graph. The background pixels are connected to
	a Sink Node, and the foreground pixels are connected to a Source Node.
	- Then the weights are added. The weight of an edge is defined by the probability of a pixel
	being foreground/backgroud and the weights between pixels are defined by their simimlarity.
	- In the end, the mincut algorithm is used to separate the source and sink nodes
'''
'''Based on this tutorial: https://docs.opencv.org/3.4/d8/d83/tutorial_py_grabcut.html'''

import numpy as np
from cv2 import *

def main():
	print("Type the name of the image:")
	name = input()
	
	try:
		img = imread(name, IMREAD_COLOR)
		mask = np.zeros(img.shape[:2], np.uint8)

		bgdModel = np.zeros((1, 65), np.float64)
		fgdModel = np.zeros((1, 65), np.float64)
		height, width, channels = img.shape

		print("Processing...")
		rect = (0, 0, height, width)
		cv2.grabCut(img, mask, rect, bgdModel, fgdModel, 10, GC_INIT_WITH_RECT)

		img = cvtColor(img, COLOR_BGR2BGRA)

		mask2 = np.where((mask == 2) | (mask == 0), 0, 1).astype('uint8')
		img[:, :, 3] = img[:, :, 3] * mask2

		cv2.imwrite(name[:-4] + '.png', img)
		cv2.imshow("Original image", img)
		cv2.waitKey(0)
		cv2.destroyAllWindows()
	except:
		print("Something went wrong")

if __name__ == '__main__':
	main()