from sklearn import datasets
import numpy
import pandas
from sklearn import tree
from sklearn import preprocessing
from sklearn.metrics import accuracy_score
import graphviz
from csv import reader
import os
os.environ["PATH"] += os.pathsep + r'D:/release/bin'


def process_data(filepath):
    # pull data from the adult.data file
    entries = pandas.read_csv(filepath)
    # here we will replace all ? fields with NaN for removal of row
    entries.replace(r'\?', numpy.nan, regex=True, inplace=True)
    print("before filtering list " + str(len(entries)) + " elements")
    # now we will drop any row with empty fields, as missing attributes
    # causes issues when creating our decision tree (cleaning data)
    entries.dropna(axis=0, how='any', inplace=True)
    print("after filtering list " + str(len(entries)) + " elements")

    target = entries.iloc[:, [14]]
    features = entries.iloc[:, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]]

    # pre processing data to be encoded
    label_encoder = preprocessing.LabelEncoder()
    # enumerates the possible values for non numeric attributes on both target and features
    target = label_encoder.fit_transform(target.values.ravel())

    pandas.options.mode.chained_assignment = None  # default='warn'
    for i in range(14):
        features.iloc[:, i] = label_encoder.fit_transform(
            features.iloc[:, i].values.ravel())
    pandas.options.mode.chained_assignment = 'warn'  # default='warn'
    return features, target


training_features, training_target = process_data('Downloads/adult.data')
clf = tree.DecisionTreeClassifier(criterion="entropy", max_depth=6)
clf.fit(training_features, training_target)

feature_title = ["age", "workclass", "fnlwgt", "education", "education-num",
                 "marital-status", "occupation", "relationship", "race", "sex",
                 "capital-gain", "capital-loss", "hours-per-week", "native-country"]

dot_data = tree.export_graphviz(
    clf, out_file=None, feature_names=feature_title, class_names=None, filled=True, rounded=True,
    special_characters=True)
graph = graphviz.Source(dot_data)
graph.render("iris")

testing_features, test_expected = process_data('Downloads/adult.test')

test_results = clf.predict(testing_features)
accuracy = accuracy_score(test_results, test_expected)
print("The accuracy of the tree was " + str(accuracy*100) + "%")
