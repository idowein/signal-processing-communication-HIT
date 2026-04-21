import matplotlib.pyplot as plt
import numpy as np

# Define parameter 'b' from the question
b = 1
limit = 2.5 * b

# Define Group 1 symbols (Dimensions 1 & 2)
S_group1 = {
    'S1': (b, b),
    'S2': (-b, b),
    'S3': (-b, -b),
    'S4': (b, -b)
}

# Define Group 2 symbols (Dimensions 3 & 4)
S_group2 = {
    'S5': (b, b),
    'S6': (-b, b),
    'S7': (-b, -b),
    'S8': (b, -b)
}

# Set up a figure with two subplots
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 8))

def plot_constellation(ax, symbols, p1_idx, p2_idx, title):
    # 1. Fill Decision Regions (Quadrants)
    ax.fill_between([0, limit], 0, limit, color='green', alpha=0.1)
    ax.fill_between([-limit, 0], 0, limit, color='blue', alpha=0.1)
    ax.fill_between([-limit, 0], -limit, 0, color='red', alpha=0.1)
    ax.fill_between([0, limit], -limit, 0, color='yellow', alpha=0.1)

    # 2. Draw Decision Boundaries (Axes)
    ax.axhline(0, color='black', linewidth=2)
    ax.axvline(0, color='black', linewidth=2)

    # 3. Set custom symbolic ticks for the axes
    tick_pos = [-2*b, -b, 0, b, 2*b]
    tick_labels = [r'$-2b$', r'$-b$', '0', r'$b$', r'$2b$']
    ax.set_xticks(tick_pos)
    ax.set_xticklabels(tick_labels)
    ax.set_yticks(tick_pos)
    ax.set_yticklabels(tick_labels)

    # 4. Add LaTeX labels for the basis functions
    ax.set_xlabel(fr'$\phi_{p1_idx}$', fontsize=18, fontweight='bold', loc='right')
    ax.set_ylabel(fr'$\phi_{p2_idx}$', fontsize=18, fontweight='bold', loc='top', rotation=0)

    # 5. Plot the symbols and adjust label positions to avoid overlap
    for name, (x, y) in symbols.items():
        ax.scatter(x, y, color='black', s=200, zorder=5)
        
        # Calculate text position offsets based on quadrant
        h_align = 'left' if x > 0 else 'right'
        h_offset = 1.1 if x > 0 else 1.1
        v_align = 'bottom' if y > 0 else 'top'
        v_offset = 0.15 if y > 0 else -0.15
        
        ax.text(x * h_offset, y + v_offset, name, fontsize=16, 
                fontweight='bold', ha=h_align, va=v_align)

    # 6. Set the updated titles as requested
    ax.set_title(title, fontsize=16, pad=20)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.set_xlim(-limit, limit)
    ax.set_ylim(-limit, limit)
    ax.set_aspect('equal')

# Plot the first projection with its updated title
plot_constellation(ax1, S_group1, 1, 2, "Method B - Symbols $S_1, S_2, S_3, S_4$")

# Plot the second projection with its updated title
plot_constellation(ax2, S_group2, 3, 4, "Method B - Symbols $S_5, S_6, S_7, S_8$")

plt.tight_layout()
plt.show()