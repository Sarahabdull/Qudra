from model import *
import time
import keyboard

def main():
    model_ = load_model('Alexnet8.h5')
    ReturnText(predict('videos.mp4', model_))

def ReturnText(text):
    from firebase import firebase
    firebase = firebase.FirebaseApplication('https://kodra-ee9a0-default-rtdb.firebaseio.com')
    firebase.put('/videoToText/', 'word', str(text))
    print(str(text))
def download():
    import urllib.request
    from firebase import firebase

    firebase = firebase.FirebaseApplication('https://kodra-ee9a0-default-rtdb.firebaseio.com')
    urllib.request.urlretrieve(
        firebase.get('/videoToText/', 'videoUrl'), 'videos.mp4')
