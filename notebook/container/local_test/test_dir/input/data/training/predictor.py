import pandas as pd

def transform_data(dataset):
    # Set features and class variables.
    dataset = dataset.values
    X = dataset[:, 1:-1]
    y = dataset[:, -1]
    # Feature Scaling
    sc = StandardScaler()
    X = sc.fit_transform(X)
    
    return pd.DataFrame(X)

if __name__ == '__main__':
    df = pd.read_csv('churn.csv')
    print(transform_data(df))