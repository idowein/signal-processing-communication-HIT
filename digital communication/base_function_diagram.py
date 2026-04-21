import matplotlib.pyplot as plt
import numpy as np

# 1. Base parameters
Ts = 1.0
t = np.linspace(0, Ts, 1000)

def get_basis_functions(Ts_val, time_vec):
    """Calculates basis functions and ensures they scale with Ts."""
    # Calculating A inside to ensure it's always tied to the provided Ts
    A_val = np.sqrt(2 / Ts_val)
    
    p1 = A_val * ((time_vec >= 0) & (time_vec < Ts_val/2))
    p2 = A_val * ((time_vec >= Ts_val/2) & (time_vec <= Ts_val))
    
    p3 = np.zeros_like(time_vec)
    p3 += A_val * ((time_vec >= 0) & (time_vec < Ts_val/4))
    p3 -= A_val * ((time_vec >= Ts_val/4) & (time_vec < Ts_val/2))
    
    p4 = np.zeros_like(time_vec)
    p4 += A_val * ((time_vec >= Ts_val/2) & (time_vec < 3*Ts_val/4))
    p4 -= A_val * ((time_vec >= 3*Ts_val/4) & (time_vec <= Ts_val))
    
    return [p1, p2, p3, p4], A_val

# 2. Generate the functions and their flipped versions (Impulse Responses)
phi_list, current_A = get_basis_functions(Ts, t)
h_list = [np.flip(p) for p in phi_list]

# 3. Visualization
fig, axes = plt.subplots(4, 1, figsize=(10, 15), sharex=True)
labels = [r'$h_1(t)$', r'$h_2(t)$', r'$h_3(t)$', r'$h_4(t)$']
colors = ['tab:blue', 'tab:blue', 'tab:red', 'tab:red']

# Font settings
LABEL_FONT = 22
TICK_FONT = 18

for i, ax in enumerate(axes):
    ax.plot(t, h_list[i], color=colors[i], lw=3)
    ax.axhline(0, color='black', lw=1.5)
    
    # Y-axis labeling
    ax.set_ylabel(labels[i], fontsize=LABEL_FONT, rotation=0, labelpad=50)
    
    # Dynamic positioning of ticks based on current_A, but with LaTeX symbolic labels
    ax.set_yticks([-current_A, 0, current_A])
    ax.set_yticklabels([r'$-\sqrt{\frac{2}{T_s}}$', '0', r'$\sqrt{\frac{2}{T_s}}$'], 
                       fontsize=TICK_FONT)
    
    ax.grid(True, linestyle='--', alpha=0.6)
    ax.set_ylim(-current_A * 1.5, current_A * 1.5)

# 4. X-axis formatting
plt.xticks([0, Ts/4, Ts/2, 3*Ts/4, Ts], 
           ['0', r'$\frac{T_s}{4}$', r'$\frac{T_s}{2}$', r'$\frac{3}{4}T_s$', r'$T_s$'],
           fontsize=TICK_FONT)

plt.xlabel('t', fontsize=LABEL_FONT, loc='right')
plt.suptitle(r'Matched Filter Impulse Responses $h_n(t) = \phi_n(T_s - t)$', fontsize=24)

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()