from anime import make_anime_transition
from maps import *
from Text_Clean import spell_checker
import os, glob, shutil
import asyncio
import cv2
import argparse
import warnings
import pyrebase
import time
import keyboard

warnings.filterwarnings("ignore")


def save(text):
    with open('input.txt', 'w', encoding='utf-8') as file_object:
        file_object.write(text)


def prepocess(text):
    processed = spell_checker(text)
    processed = processed.replace(' ', '_')
    save(processed)
    return processed


class EchoClientProtocol(asyncio.Protocol):
    def __init__(self, message, on_con_lost):
        self.message = message
        self.on_con_lost = on_con_lost

    def connection_made(self, transport):
        transport.write(self.message.encode())
        print('Data sent: {!r}'.format(self.message))

    def data_received(self, data):
        print('Data received: {!r}'.format(data.decode()))

    def connection_lost(self, exc):
        print('The server closed the connection')
        self.on_con_lost.set_result(True)


async def main(nframes, file_path):
    # Get a reference to the event loop as we plan to use
    # low-level APIs.
    loop = asyncio.get_running_loop()
    on_con_lost = loop.create_future()
    message = str(nframes) + ',' + file_path
    print(nframes)
    transport, protocol = await loop.create_connection(
        lambda: EchoClientProtocol(message, on_con_lost),
        '127.0.0.3', 8888)

    # Wait until the protocol signals that the connection
    # is lost and close the transport.
    try:
        await on_con_lost
    finally:
        transport.close()

def init(text):
    processed_text = prepocess(text)
    print("text clean:", processed_text)

    with open('input.txt', encoding='utf-8') as f:
        lines = f.readlines()

    sentence = [BVHMOVE.get(ENGTOARB.get(w)) for w in lines[0].split()]
    file_path = ' '.join(sentence) #Moves/hello_motion_coord.bvh
    _, _, after_keyword = file_path.partition('Moves/')
    file_path, _, _ = after_keyword.partition('.bvh')
    f.close()
    print(lines)
    print(sentence)
    print(file_path)
    Status = None
    nframes = make_anime_transition(sentence)
    asyncio.run(main(nframes, file_path))


if __name__ == '__main__':
    text =input()
    init(text)

