FROM python:3.6

ADD VERSION /

ADD requirements.txt /

RUN pip install -r requirements.txt

ADD python_stack_ffter.py /

ADD python_3d_fft_heatmap_constructor.py /

CMD ["python", "python_stack_ffter.py"]