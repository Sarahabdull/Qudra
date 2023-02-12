from ar_corrector.corrector import Corrector

def spell_checker(sentence):
    corr = Corrector()
    sentence = corr.contextual_correct(sentence)
    return sentence


