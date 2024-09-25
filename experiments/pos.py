# used python 3.11.9
# spacy==3.7.6

import spacy


def extract_pos(input_sentence):
    # python -m spacy download nl_core_news_sm
    # python -m spacy download nl_core_news_md
    model = spacy.load("nl_core_news_md")
    doc = model(input_sentence)
    for token in doc:
        print(token.text, token.pos_, token.dep_,)


if __name__ == "__main__":
    input_sentence = "kan ik de binnenmuur veranderen door dubbele ramen?"
    extract_pos(input_sentence=input_sentence)
