#!/usr/bin/env python

import os
from faster_whisper import WhisperModel
from sentence_transformers import SentenceTransformer, CrossEncoder


def load_model(env: str, clazz, **kwargs):
    kwargs["device"] = "cpu"

    model = os.environ.get(env)
    if model:
        print(f"Loading model {model} for {clazz.__name__}...")
        clazz(model, **kwargs)


if __name__ == "__main__":
    load_model("RAG_EMBEDDING_MODEL", SentenceTransformer)
    load_model("RAG_RERANKING_MODEL", CrossEncoder)
    load_model(
        "WHISPER_MODEL",
        WhisperModel,
        compute_type="int8",
        download_root=os.environ.get("WHISPER_MODEL_DIR"),
    )
