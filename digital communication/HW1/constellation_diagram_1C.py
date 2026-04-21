import matplotlib.pyplot as plt
import numpy as np

a = 1 # amplitude definiton

S = { # 4 symbol constelation
    'S1': (a, a), 
    'S2': (-a, a),
    'S3': (-a, -a),
    'S4': (a, -a)
}

plt.figure(figsize = (8,8)) # Create a square figure for proportional axes

# 1. Visualize Decision Regions using background colors
limit = 2.5 # X and Y axis size
# Quadrant 1 (D1) - Top Right
plt.fill_between([0, limit], 0, limit, color='green', alpha=0.1)
# Quadrant 2 (D2) - Top Left
plt.fill_between([-limit, 0], 0, limit, color='blue', alpha=0.1)
# Quadrant 3 (D3) - Bottom Left
plt.fill_between([-limit, 0], -limit, 0, color='red', alpha=0.1)
# Quadrant 4 (D4) - Bottom Right
plt.fill_between([0, limit], -limit, 0, color='yellow', alpha=0.1)

# 2. Draw Decision Boundaries (The X and Y axes)
plt.axhline(0, color='black', linewidth=2)
plt.axvline(0, color='black', linewidth=2)

# 3. SET CUSTOM AXIS TICKS (Replacing numbers with 'a', '2a', etc.)
# Define tick positions and their corresponding LaTeX labels
tick_pos = [-2*a, -a, 0, a, 2*a]
tick_labels = [r'$-2a$', r'$-a$', '0', r'$a$', r'$2a$']

plt.xticks(tick_pos, tick_labels, fontsize=12)
plt.yticks(tick_pos, tick_labels, fontsize=12)

# 4. Add axis labels using LaTeX notation for phi1 and phi2
# 'loc' sets the label position at the end of the axes
# 'rotation=0' keeps the Y-axis label horizontal for readability
plt.xlabel(r'$\phi_1$', fontsize=18, fontweight='bold', loc='right')
plt.ylabel(r'$\phi_2$', fontsize=18, fontweight='bold', loc='top', rotation=0)

# 5. Plot the ideal symbols and their respective labels
for name, (x, y) in S.items():
    # Plot the point
    plt.scatter(x, y, color='black', s=200, zorder=5)
    # Add symbol name (S1-S4) near the point
    plt.text(x*1.25, y*1.25, name, fontsize=16, fontweight='bold', ha='center')

# 6. Final plot styling and formatting
plt.title('1C constellation diagram', fontsize=14)
plt.grid(True, linestyle=':', alpha=0.6)
plt.xlim(-limit, limit)
plt.ylim(-limit, limit)
# Ensure the aspect ratio is 1:1 so circles/squares look correct
plt.gca().set_aspect('equal')

# Display the final diagram
plt.show()