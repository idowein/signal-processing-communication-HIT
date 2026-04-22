import matplotlib.pyplot as plt
import numpy as np

# 1. Base parameters
Ts, A = 1.0, 1.0 
C_val = (A / 2) * np.sqrt(2 * Ts)
C_label = r'$\frac{A}{2}\sqrt{2T_s}$'

s_vectors = {
    's1': [1, 1, 0, 0], 's3': [1, -1, 0, 0],
    's2': [0, 0, -1, -1], 's4': [0, 0, 1, -1]
}

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 10))

def draw_clean_decision_regions(ax, title, x_label, y_label, points, idx, mode):
    limit = C_val * 2.5
    ax.set_xlim(-limit, limit)
    ax.set_ylim(-limit, limit)
    
    # --- Decision Regions Mapping ---
    if mode == 'horizontal_split':
        # Only horizontal boundary exists (X-axis is the boundary)
        ax.fill_between([-limit, limit], 0, limit, color='#e3f2fd', alpha=0.6, zorder=0) # Top
        ax.fill_between([-limit, limit], -limit, 0, color='#e8f5e9', alpha=0.6, zorder=0) # Bottom
        # Draw ONLY the horizontal boundary bold
        ax.axhline(0, color='black', lw=4, zorder=2) 
        ax.axvline(0, color='black', lw=1, alpha=0.3, zorder=1) # Thin reference line
    else:
        # Only vertical boundary exists (Y-axis is the boundary)
        ax.axvspan(-limit, 0, color='#ffebee', alpha=0.6, zorder=0) # Left
        ax.axvspan(0, limit, color='#fffde7', alpha=0.6, zorder=0) # Right
        # Draw ONLY the vertical boundary bold
        ax.axvline(0, color='black', lw=4, zorder=2)
        ax.axhline(0, color='black', lw=1, alpha=0.3, zorder=1) # Thin reference line

    # Formatting and Points
    ax.set_title(title, fontsize=26, pad=20, fontweight='bold')
    ax.set_xlabel(x_label, fontsize=24, loc='right')
    ax.set_ylabel(y_label, fontsize=24, loc='top', rotation=0)

    for name in points:
        vec = s_vectors[name]
        x, y = vec[idx[0]] * C_val, vec[idx[1]] * C_val
        ax.scatter(x, y, color='black', s=500, zorder=5, edgecolor='white', lw=2)
        ax.text(x, y + (limit*0.1), name.upper(), fontsize=24, fontweight='bold', ha='center')

    # Axis Ticks
    ax.set_xticks([-C_val, 0, C_val]); ax.set_yticks([-C_val, 0, C_val])
    ax.set_xticklabels([f'-{C_label}', '0', C_label], fontsize=16)
    ax.set_yticklabels([f'-{C_label}', '0', C_label], fontsize=16)
    ax.set_aspect('equal')

# Plotting
draw_clean_decision_regions(ax1, 'Decision: $S_1$ (Top) vs $S_3$ (Bottom)', '$u_1$', '$u_2$', 
                            ['s1', 's3'], [0, 1], 'horizontal_split')

draw_clean_decision_regions(ax2, 'Decision: $S_2$ (Left) vs $S_4$ (Right)', '$u_3$', '$u_4$', 
                            ['s2', 's4'], [2, 3], 'vertical_split')

plt.tight_layout()
plt.show()