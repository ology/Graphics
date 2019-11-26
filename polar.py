import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#np.random.seed(42)

# Set the boudaries
n = 20
high = 3

# Get the data
theta = np.linspace(0.0, 2 * np.pi, n, endpoint=False)
radii = 10 * np.random.rand(n)

# Make a polar scatter plot
ax = plt.subplot(111, projection='polar')
ax.scatter(theta, radii)

# Make a dataframe
df = pd.DataFrame({"theta": theta, "radii": radii})

# Plot a random sample of items
#samp = df.sample(n)
#print(samp)
#plt.plot(samp.theta, samp.radii, 'k-')
#plt.show()

# Make a random network of index nodes column
net = []

for i in range(len(df)):
    roll = np.random.randint(low=0, high=high)
    #print('Roll:', roll)

    nodes = []
    
    for j in range(roll):
        nodes.append(str(np.random.randint(low=0, high=n)))
    
    net.append(' '.join(nodes))

df['net'] = net
print(df)

# Plot lines between the nodes based on the net column
for i in range(len(df)):
    for j in df.loc[i, 'net'].split():
        #print(i, j)

        x0 = df.loc[i, 'theta']
        y0 = df.loc[i, 'radii']

        j = int(j)
        x1 = df.loc[j, 'theta']
        y1 = df.loc[j, 'radii']

        ax.annotate('',
            xy=(x0, y0), xycoords='data',
            xytext=(x1, y1), textcoords='data',
            arrowprops=dict(arrowstyle='->', connectionstyle='arc3', color='green'),
            )

plt.show()
