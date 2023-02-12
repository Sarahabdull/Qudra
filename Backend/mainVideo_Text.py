from video import *
from Text_Clean import spell_checker
import glob
import cv2
import warnings
import pyrebase
import keyboard
warnings.filterwarnings("ignore")


def save(text):
    with open('input' + '.txt', 'w', encoding='utf-8') as file_object:
        file_object.write(text)


def prepocess(text):
    text = text.replace(' ','_')
    processed = spell_checker(text)
    save(processed)
    return processed

def GetText():
    import urllib.request
    from firebase import firebase

    firebase = firebase.FirebaseApplication('https://kodra-ee9a0-default-rtdb.firebaseio.com')
    return firebase.get('/wordToVideo/', 'word')


def init(text):

    print(text)
    processed_text = prepocess(text)
    print("text clean:", processed_text)
    with open('input.txt', encoding='utf-8') as f:
        lines = f.readlines()

    path = ''.join([VideoMove.get(ENGTOARB.get(w)) for w in lines[0].split() if w in ENGTOARB])
    if path == '':
        path = './Other_rendering/*.jpg'
    print(path)
    files = sorted(glob.glob(path), key=lambda x: int(x.split("\\")[1][:-4]))

    # load all Frame in This Array
    img_array = []
    for filename in files:
        img = cv2.imread(filename)
        height, width, layers = img.shape
        size = (width, height)
        img_array.append(img)
    # Output Path
    vid_path = 'output.mp4'
    out = cv2.VideoWriter(vid_path, cv2.VideoWriter_fourcc(*'XVID'), 12, size)

    # Write Video
    for i in range(len(img_array)):
        out.write(img_array[i])
    out.release()

    return False

def UploadVideo():
    firebaseConfig = {
        "apiKey": "AIzaSyCbNNl0OF0_PRDto_KTNWQfSNS5PvgDi0k",
        "authDomain": "kodra-ee9a0.firebaseapp.com",
        "databaseURL": "https://kodra-ee9a0-default-rtdb.firebaseio.com",
        "projectId": "kodra-ee9a0",
        "storageBucket": "kodra-ee9a0.appspot.com",
        "messagingSenderId": "646286184110",
        "appId": "1:646286184110:web:989b17cde058f9b985e73f",
        "measurementId": "G-RRR5Y10J48",
        "serviceAccount": "serviceAccountKey.json"
    }
    firebase = pyrebase.initialize_app(firebaseConfig)
    storage = firebase.storage()
    storage.child("output.mp4").put("output.mp4")

    from firebase.firebase import FirebaseAuthentication,FirebaseApplication

    email = "xxxx@gmail.com"
    password = "xxxx"
    authentication = FirebaseAuthentication(password,email)
    firebase.authentication = authentication
    user = authentication.get_user()
    print(user.firebase_auth_token)

    #user = auth.sign_in_with_email_and_password(email, password)
    url = storage.child("output.mp4").get_url(user.firebase_auth_token)
    print(url)

    firebase = FirebaseApplication('https://kodra-ee9a0-default-rtdb.firebaseio.com')
    firebase.put('/wordToVideo/', 'videoUrl', str(url))
    print(str(url))
