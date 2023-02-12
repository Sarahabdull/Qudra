import os
import numpy as np
import cv2
from tqdm import tqdm
from sklearn.model_selection import train_test_split

IMG_SIZE = 64
DataPath = 'Arabic_Database/'
class_ = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'ain', 'al', 'aleff', 'bb', 'dal', 'dha', 'dhad', 'fa',
          'gaaf', 'ghain', 'ha', 'haa', 'jeem', 'kaaf', 'khaa',
          'la', 'laam', 'meem', 'nun', 'ra', 'saad', 'seen', 'sheen', 'ta', 'taa', 'thaa', 'thal', 'toot', 'waw', 'ya',
          'yaa', 'zay']

def preprocessing():
    training_data = []
    for category in class_:
        path = os.path.join(DataPath, category)
        class_num = class_.index(category)

        for img in tqdm(os.listdir(path)):
            image = cv2.imread(os.path.join(path, img), cv2.IMREAD_GRAYSCALE)  # convert to array
            image = cv2.resize(image, (IMG_SIZE, IMG_SIZE))  # resize to normalize data size
            training_data.append([image, class_num])

    return training_data

def splitDate(training_data):
    feature = []
    label = []

    for x, y in training_data:
        feature.append(x)
        label.append(y)

    feature = np.array(feature).reshape(-1, IMG_SIZE, IMG_SIZE)
    label = np.array(label)

    X_train, X_test, y_train, y_test = train_test_split(feature, label, test_size=0.2, random_state=44, shuffle=True)
    return X_train, X_test, y_train, y_test