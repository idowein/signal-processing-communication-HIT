import matplotlib.pyplot as plt
import numpy as np

# 1. Define parameters
Ts = 1.0  # Symbol time (normalized)
A = np.sqrt(4 / Ts)  # Amplitude for unit energy
t = np.linspace(0, Ts, 1000)  # Time vector

# 2. Define the requested basis functions (3 and 4)
phi3 = np.zeros_like(t)
phi3[(t >= 0) & (t < Ts/4)] = A
phi3[(t >= Ts/4) & (t < Ts/2)] = -A

phi4 = np.zeros_like(t)
phi4[(t >= Ts/2) & (t < 3*Ts/4)] = A
phi4[(t >= 3*Ts/4) & (t <= Ts)] = -A

# 3. Create the visualization (Only 2 subplots as requested)
fig, axes = plt.subplots(2, 1, figsize=(10, 8), sharex=True)
functions = [phi3, phi4]
labels = [r'$\phi_3(t)$', r'$\phi_4(t)$']
colors = ['tab:red', 'tab:red']

# --- FONT SIZE PARAMETERS ---
AXIS_LABEL_FONT = 22  # Font for phi3, phi4 and 't'
TICK_LABEL_FONT = 22  # Font for the numbers/fractions on axes
TITLE_FONT = 24       # Font for the main title

for i, ax in enumerate(axes):
    # Plot each function
    ax.plot(t, functions[i], color=colors[i], lw=3)
    
    # Add horizontal line at zero
    ax.axhline(0, color='black', lw=1.5)
    
    # Label Y-axis with enlarged font
    ax.set_ylabel(labels[i], fontsize=AXIS_LABEL_FONT, rotation=0, labelpad=45)
    
    # Set Y-axis ticks and their font size
    ax.set_yticks([-A, 0, A])
    ax.set_yticklabels([r'$-\sqrt{\frac{2}{T_s}}$', '0', r'$\sqrt{\frac{2}{T_s}}$'])
    ax.tick_params(axis='y', labelsize=TICK_LABEL_FONT)
    
    # Add grid and limit display
    ax.grid(True, linestyle='--', alpha=0.5)
    ax.set_ylim(-A*1.5, A*1.5)

# 4. Format X-axis with enlarged font and custom ticks
plt.xticks([0, Ts/4, Ts/2, 3*Ts/4, Ts], 
           ['0', r'$\frac{T_s}{4}$', r'$\frac{T_s}{2}$', r'$\frac{3T_s}{4}$', r'$T_s$'],
           fontsize=TICK_LABEL_FONT)

plt.xlabel('t', fontsize=AXIS_LABEL_FONT, loc='right')
plt.suptitle(r'Proposed Basis Functions $\phi_3(t)$ and $\phi_4(t)$', fontsize=TITLE_FONT)

# Adjust layout to prevent labels from being cut off
plt.tight_layout(rect=[0, 0.03, 1, 0.95])

# Save the result
plt.savefig('basis_functions_3_4_enlarged.png')
plt.show()