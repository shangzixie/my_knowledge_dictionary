import tkinter as tk
from tkinter import filedialog
import torch.nn.functional as F
import pandas as pd
from PIL import ImageTk, Image
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import torch
import torchvision.transforms as transforms
import torchvision.models as models
import matplotlib

img = None


def main():
    plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
    plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
    matplotlib.rc("font", family='SimHei')  # 中文字体

    root = tk.Tk()
    createButton(root)
    root.mainloop()

def createButton(rootTK):
    rootTK.geometry('850x600')
    rootTK.title('图像分类器')
    button = tk.Button(rootTK, text='选择图片', command=lambda: loadImage(rootTK))
    button.place(x=370, y=520)

def loadImage(rootTK):
    global img
    img_path = filedialog.askopenfilename()
    img_tk = Image.open(img_path).resize((350, 400))
    img = ImageTk.PhotoImage(img_tk)
    # 创建Canvas显示图像
    image_canvas = tk.Canvas(rootTK, width=350, height=400)
    image_canvas.pack(side=tk.LEFT, padx=20, pady=20)
    # 显示图片
    image_canvas.create_image(0, 0, anchor=tk.NW, image=img)

    # get data
    x, y = handleTransform(img_tk)
    # draw figure
    figure = plt.Figure(figsize=(8, 4), dpi=100)
    ax = figure.add_subplot(111)
    ax.barh(x, y)
    # add figure into canvas
    canvas = FigureCanvasTkAgg(figure, master=rootTK)
    canvas.get_tk_widget().pack(side=tk.LEFT, padx=20, pady=20)
    # render

    # image_canvas.draw()
    canvas.draw()

def handleTransform(img):
    labels = {}
    df = pd.read_csv('imagenet_class_index.csv')
    for idx, row in df.iterrows():
        labels[row['ID']] = [row['wordnet'], row['Chinese']]

    transform = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225])
    ])
    # 加载ResNet18模型
    device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
    model = models.resnet18(pretrained=True)
    model.eval()
    model = model.to(device)
    image_tensor = transform(img).unsqueeze(0).to(device)
    with torch.no_grad():
        output = model(image_tensor)
        probabilities = F.softmax(output, dim=1)
    n = 5
    top_n = torch.topk(probabilities, n)  # 取置信度最大的 n 个结果
    pred_ids = top_n[1].cpu().detach().numpy().squeeze()  # 解析出类别
    confs = top_n[0].cpu().detach().numpy().squeeze()  # 解析出置信度
    namelist = []
    x = []
    y = []
    for i in range(n):
        class_name = labels[pred_ids[i]][1]
        namelist.append(labels[pred_ids[i]][1])  # 获取类别名称
        confidence = confs[i] * 100  # 获取置信度
        text = '{:<15} {:>.4f}'.format(class_name, confidence)
        x.append(class_name)
        y.append(confidence)
        print(text)
    return x, y

if __name__ == "__main__":
    main()
