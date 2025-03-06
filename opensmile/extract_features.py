"""
run.py
generate OSM features on WAV files;
"""
import os
from osm import extract_osm_features

def extract(audio_fp, **kwargs):
    """
    extract features from an audio file
    Inputs: audio_fp: filepath to the audio file
            feat_level (optional): feature level, default is lld
            feat_set (optional): feature set, default is ComPareE_2016
    """
    feat_level = kwargs.get('feat_level', 'lld')
    feat_set = kwargs.get('feat_set', 'ComPareE_2016')
    basename = os.path.basename(audio_fp).split('.')[0]
    csv_out = f'sample_out/{basename}_{feat_level}_{feat_set}.csv'
    extract_osm_features(audio_fp, csv_out, feat_level, feat_set)

def main():
    """
    main entrypoint
    """
    extract('sample_wav/first_ten_Sample_HV_Clip.wav')
    extract('sample_wav/first_ten_Sample_HV_Clip.wav', feat_level='func')

if __name__ == '__main__':
    main()
