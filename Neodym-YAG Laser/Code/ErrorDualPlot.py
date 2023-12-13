import matplotlib.pyplot as plt


def extractLineValues(fileLine, seperator=","):
    lineValues = []
    for v in fileLine.split(seperator):
        try:
            lineValues.append(float(v))
        except:
            pass

    return lineValues


def readFile(filePath, cutoff=0, seperator=","):
    xData, y1Data, y2Data = [], [], []

    with open(filePath, "r") as f:
        fileLines = f.readlines()[cutoff:]

        for fileLine in fileLines:
            x, y1, y2 = extractLineValues(fileLine, seperator)
            xData.append(x)
            y1Data.append(y1)
            y2Data.append(y2)

    return xData, y1Data, y2Data


def createErrorDualPlot(xData, y1Data, y2Data, y1DataError=[], y2DataError=[], y1DataLabel="", y2DataLabel="",
                        xLabel="", yLabel=""):

    if len(y1DataError) == 0:
        y1DataError = list(0 for _ in y1Data)
    if len(y2DataError) == 0:
        y2DataError = list(0 for _ in y2Data)

    plt.errorbar(xData, y1Data, yerr=y1DataError, label=y1DataLabel)
    plt.errorbar(xData, y2Data, yerr=y2DataError, label=y2DataLabel)

    plt.legend(fontsize=14)
    plt.xlabel(xLabel, fontsize=14)
    plt.ylabel(yLabel, fontsize=14)

    plt.show()
