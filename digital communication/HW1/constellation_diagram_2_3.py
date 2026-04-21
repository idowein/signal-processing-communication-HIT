import matplotlib.pyplot as plt
import numpy as np

# 1. Base parameters from Question 2
Ts = 1.0
A = 1.0 
C_val = (A / 2) * np.sqrt(2 * Ts)

# Define the symbols as vectors [u1, u2, u3, u4]
s_vectors = {
    's1': [1, 1, 0, 0],
    's3': [1, -1, 0, 0],
    's2': [0, 0, -1, -1],
    's4': [0, 0, 1, -1]
}

# 2. Setup the Visualization
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 10))

# Styling constants
LABEL_FONT = 24
TITLE_FONT = 26
POINT_SIZE = 450

def draw_decision_constellation(ax, title, x_label, y_label, points_to_plot, comp_idx, mode='horizontal'):
    limit = C_val * 2.5
    ax.set_xlim(-limit, limit)
    ax.set_ylim(-limit, limit)
    
    # --- Decision Regions Logic ---
    if mode == 'horizontal':
        # Left Plot: S1 (Top half) vs S3 (Bottom half)
        ax.fill_between([-limit, limit], 0, limit, color='#e3f2fd', alpha=0.6, zorder=0, label='Region S1')
        ax.fill_between([-limit, limit], -limit, 0, color='#e8f5e9', alpha=0.6, zorder=0, label='Region S3')
    else:
        # Right Plot: S2 (Left half) vs S4 (Right half)
        ax.axvspan(-limit, 0, color='#ffebee', alpha=0.6, zorder=0, label='Region S2')
        ax.axvspan(0, limit, color='#fffde7', alpha=0.6, zorder=0, label='Region S4')

    # Draw bold axes
    ax.axhline(0, color='black', lw=3.5, zorder=2)
    ax.axvline(0, color='black', lw=3.5, zorder=2)
    
    # Set titles and axis labels
    ax.set_title(title, fontsize=TITLE_FONT, pad=20, fontweight='bold')
    ax.set_xlabel(x_label, fontsize=LABEL_FONT, loc='right')
    ax.set_ylabel(y_label, fontsize=LABEL_FONT, loc='top', rotation=0)

    # Plot points
    for name in points_to_plot:
        vec = s_vectors[name]
        x, y = vec[comp_idx[0]] * C_val, vec[comp_idx[1]] * C_val
        
        # Draw the black dot
        ax.scatter(x, y, color='black', s=POINT_SIZE, zorder=5, edgecolor='white', lw=2)
        
        # Draw label (S1, S2, etc.)
        ax.text(x, y + (limit*0.1), name.upper(), fontsize=24, 
                fontweight='bold', ha='center', zorder=6)

    # Formatting ticks
    label_C = r'$\frac{A}{2}\sqrt{2T_s}$'
    ax.set_xticks([-C_val, 0, C_val])
    ax.set_xticklabels([f'-{label_C}', '0', label_C], fontsize=16)
    ax.set_yticks([-C_val, 0, C_val])
    ax.set_yticklabels([f'-{label_C}', '0', label_C], fontsize=16)
    
    ax.grid(True, linestyle=':', alpha=0.4)
    ax.set_aspect('equal')

# --- Plot Left: Plane (u1, u2) ---
# S1 is (C, C), S3 is (C, -C). Decision boundary is the X-axis (u1).
draw_decision_constellation(ax1, 'Decision Regions: $S_1$ vs $S_3$', '$u_1$', '$u_2$', 
                            ['s1', 's3'], [0, 1], mode='horizontal')

# --- Plot Right: Plane (u3, u4) ---
# S2 is (-C, -C), S4 is (C, -C). Decision boundary is the Y-axis (u4).
draw_decision_constellation(ax2, 'Decision Regions: $S_2$ vs $S_4$', '$u_3$', '$u_4$', 
                            ['s2', 's4'], [2, 3], mode='vertical')

plt.tight_layout()
plt.show()