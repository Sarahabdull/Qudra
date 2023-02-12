from mainText_Video import *
from mainVideo_Text import *
if __name__ == '__main__':
    while True:

            if keyboard.is_pressed('q'):
                break
            download()
            main()
            time.sleep(2)
            Text = GetText()
            init(Text)
            UploadVideo()
            time.sleep(2)


