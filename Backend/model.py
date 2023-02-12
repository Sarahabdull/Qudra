import numpy as np
import cv2
import keras
from keras.layers.core import Dense
from sklearn.model_selection import KFold
from sklearn.metrics import classification_report

character_ = {'0':0,
        '1':1,
        '2':2,
        '3':3,
        '4':4,
        '5':5,
        '6':6,
        '7':7,
        '8':8,
        '9':9,
        'ع':10,
        'ال':11,
        'أ':12,
        'ب':13,
        'د':14,
        'ظ':15,
        'ض':16,
        'ف':17,
        'ق':18,
        'غ':19,
        'ه':20,
        'ح':21,
        'ج':22,
        'ك':23,
        'خ':24,
        'لا':25,
        'ل':26,
        'م':27,
        'ن':28,
        'ر':29,
        'ص':30,
        'س':31,
        'ش':32,
        'ط':33,
        'ت':34,
        'ث':35,
        'ذ':36,
        'ة':37,
        'و':38,
        'ئ':39,
        'ي':40,
        'ز':41,}

def getCharacter(s) :
    for i , j in character_.items() :
        if s == j :
            return i

def build_model(inputs, targets):
    kfold = KFold(n_splits=10, shuffle=True)
    IMG_SIZE = 64
    for train, test in kfold.split(inputs, targets):
        Model2_AlexNet = keras.models.Sequential([
            keras.layers.Conv2D(filters=96, kernel_size=(3, 3), activation='relu', strides=(1, 1), padding='valid',
                                input_shape=(IMG_SIZE, IMG_SIZE, 1)),
            keras.layers.MaxPooling2D(pool_size=(2, 2), strides=(2, 2), padding='valid'),

            keras.layers.Conv2D(filters=96, activation='relu', kernel_size=(3, 3), strides=(1, 1), padding='valid'),
            keras.layers.BatchNormalization(),

            keras.layers.Conv2D(filters=256, kernel_size=(3, 3), strides=(1, 1), activation='relu', padding='valid'),
            keras.layers.MaxPooling2D(pool_size=(2, 2), strides=(2, 2), padding='valid'),

            keras.layers.Conv2D(filters=256, activation='relu', kernel_size=(3, 3), strides=(1, 1), padding='valid'),
            keras.layers.BatchNormalization(),

            keras.layers.Conv2D(filters=384, activation='relu', kernel_size=(3, 3), strides=(1, 1), padding='valid'),
            keras.layers.BatchNormalization(),

            keras.layers.Conv2D(filters=384, kernel_size=(3, 3), strides=(1, 1), activation='relu', padding='valid'),
            keras.layers.BatchNormalization(),

            keras.layers.Conv2D(filters=256, activation='relu', kernel_size=(3, 3), strides=(1, 1), padding='valid'),
            keras.layers.BatchNormalization(),

            keras.layers.Conv2D(filters=256, kernel_size=(3, 3), strides=(1, 1), activation='relu', padding='valid'),
            keras.layers.MaxPooling2D(pool_size=(2, 2), strides=(2, 2), padding='valid'),
            keras.layers.BatchNormalization(),

            keras.layers.Flatten(),

            keras.layers.Dense(4096, activation='relu'),
            keras.layers.Dropout(rate=0.4),
            keras.layers.BatchNormalization(),

            keras.layers.Dense(4096, activation='relu'),
            keras.layers.Dropout(rate=0.4),
            keras.layers.BatchNormalization(),

            keras.layers.Dense(42, activation='softmax')
        ])
        Model2_AlexNet.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
        epochs = 25
        history_AlexNet = Model2_AlexNet.fit(inputs[train], targets[train], epochs=epochs, batch_size=64,
                                             validation_data=(inputs[test], targets[test],), verbose=1)
        Model2_AlexNet.save('Alexnet8.h5')
        return Model2_AlexNet

def load_model(x):
    Model2_AlexNet = keras.models.load_model(x)
    return Model2_AlexNet

def evaluateModel(model_,X_test, y_test):
    y_pred = model_.predict(X_test)
    predicted_classes = np.argmax(y_pred, axis=1)
    print("Result of Classification_Report:____________________________________________________\n")
    print(classification_report(y_test, np.array(predicted_classes)))

def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.2989, 0.5870, 0.1140])

def predict(pathIn,model_):
    symbols = []
    IMG_SIZE = 64
    vidcap = cv2.VideoCapture(pathIn)
    frameCount = int(vidcap.get(cv2.CAP_PROP_FRAME_COUNT))
    print(frameCount)
    count = 0
    t = 1

    while (True):

        success, image = vidcap.read()

        if success:
            image = rgb2gray(image)
            image = cv2.resize(image, (IMG_SIZE, IMG_SIZE))
            X_pred_array = np.array(image).reshape(-1, IMG_SIZE, IMG_SIZE) # 64X64X1

            y = model_.predict(np.array(X_pred_array))
            #print(getCharacter(np.argmax(y)))
            symbols.append(getCharacter(np.argmax(y)))

        else:
            break
    return max(set(symbols), key=symbols.count)