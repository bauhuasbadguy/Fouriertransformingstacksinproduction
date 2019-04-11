FROM python:3.6

ADD requirements.txt /

RUN pip install -r requirement.txt

ADD python_multiple_3D_ffter.py /

ADD python_3d_fft_heatmap_constructor.py /

CMD ["python", "python_multiple_3D_ffter.py"]