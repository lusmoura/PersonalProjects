''' This version of the code has an interface that allows the user to choose
a picture and to draw a rectangle in a specific area.
The grab cut is the same, but some UI things were added

Based on this tutorial: https://www.youtube.com/watch?v=HBp6vQXFQgc&index=15&list=PL-t7zzWJWPtx3enns2ZAV6si2p9zGhZJX
'''

from tkinter import *
from PIL import Image
from PIL import ImageTk
from tkinter import filedialog
import cv2
import numpy as np

class GrabCut(Frame):
    def __init__(self, master = None):
        try:
            Frame.__init__(self, master)
        
            self.startUI()
        except:
            print("Something wrong with constructor")

    def startUI(self):
        try:
            self.master.title("Picture")
            self.pack()

            self.mouseActions()

            self.img = self.loadImage()

            self.canvas = Canvas(self.master, width = self.img.width(), height = self.img.height(), cursor = "cross")

            self.canvas.create_image(0, 0, anchor = NW, image = self.img)
            self.canvas.image = self.img

            self.canvas.pack()
        except:
            print("Something wrong with the UI")

    def mouseActions(self):
        self.startX = None
        self.startY = None
        self.rect   = None
        self.existRectangle = None
        
        self.master.bind("<ButtonPress-1>", self.mousePressed)
        self.master.bind("<B1-Motion>", self.movingMouse)
        self.master.bind("<ButtonRelease-1>", self.mouseReleased)

    def mouseReleased(self, event):
        try:
            if self.existRectangle == True:
                windowGrabCut = Toplevel(self.master)
                windowGrabCut.wm_title("Grab Cut")
                windowGrabCut.minsize(width= self.img.width(), height= self.img.height())

                canvasGrabCut = Canvas(windowGrabCut, width= self.img.width(), height= self.img.height())
                canvasGrabCut.pack()

                mask = np.zeros(self.imagemOpenCV.shape[:2], np.uint8)
                rect = (int(self.startX), int(self.startY), int(event.x - self.startX), int(event.y - self.startY))
                bgdModel = np.zeros((1,65), np.float64)
                fgdModel = np.zeros((1,65), np.float64)
                iteractions = 5

                cv2.grabCut(self.imagemOpenCV, mask, rect, bgdModel, fgdModel, iteractions, cv2.GC_INIT_WITH_RECT)

                mask2 = np.where((mask == 0) | (mask == 2), 0, 1).astype("uint8")
                final = self.imagemOpenCV * mask2[:, :, np.newaxis]
                
                final = cv2.cvtColor(final, cv2.COLOR_BGR2BGRA)
                final[:, :, 3] = final[:, :, 3] * mask2

                cv2.imwrite("imagem.png", final)
                
                final = cv2.cvtColor(final, cv2.COLOR_BGR2RGB)
                final = Image.fromarray(final)
                final = ImageTk.PhotoImage(final)

                canvasGrabCut.create_image(0, 0, anchor= NW, image= final)
                canvasGrabCut.image = final
        except:
            print("Something wrong with the grab cut")
    
    def movingMouse(self, event):
        try:
            currentX = self.canvas.canvasx(event.x)
            currentY = self.canvas.canvasy(event.y)

            self.canvas.coords(self.rect, self.startX, self.startY, currentX, currentY)

            self.existRectangle = True
        except:
            print("Something wrong with moving mouse")

    def mousePressed(self, event):
        try:
            self.startX = self.canvas.canvasx(event.x)
            self.startY = self.canvas.canvasy(event.y)

            if not self.rect:
                self.rect = self.canvas.create_rectangle(0, 0, 0, 0, outline="red")
        except:
            print("Something wrong with pressing the mouse button")

    def loadImage(self):
        try:
            path = filedialog.askopenfilename()

            if(len(path) > 0):
                self.imagemOpenCV = cv2.imread(path)

                image = cv2.cvtColor(self.imagemOpenCV, cv2.COLOR_BGR2RGB)
                image = Image.fromarray(image)
                image = ImageTk.PhotoImage(image)

                return image
        except:
            print("Something wrong with loading the image")

def main():
    root = Tk()
    appcut = GrabCut(master = root)
    appcut.mainloop()

if __name__ == "__main__":
    main()