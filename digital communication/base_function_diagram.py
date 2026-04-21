import matplotlib.pyplot as plt
import numpy as np

# 1. Base parameters
Ts = 1.0
t = np.linspace(0, Ts, 1000)
A = 1.0 
peak = A * np.sqrt(2) # Theoretical peak

def get_basis_functions(Ts_val, time_vec):
    amp = 2 / np.sqrt(Ts_val)
    u1 = amp * ((time_vec >= 0) & (time_vec < Ts_val/4))
    u2 = amp * ((time_vec >= Ts_val/4) & (time_vec < Ts_val/2))
    u3 = amp * ((time_vec >= Ts_val/2) & (time_vec < 3*Ts_val/4))
    u4 = amp * ((time_vec >= 3*Ts_val/4) & (time_vec <= Ts_val))
    return [u1, u2, u3, u4]

def generate_signal_from_vector(vector, A_param, Ts_val, time_vec):
    basis_set = get_basis_functions(Ts_val, time_vec)
    scaling_factor = (A_param / 2) * np.sqrt(2 * Ts_val)
    st = np.zeros_like(time_vec)
    for i in range(len(vector)):
        st += vector[i] * basis_set[i]
    return st * scaling_factor

# 2. Define vectors from Question 2
s_vectors = {
    's1': [1, 1, 0, 0],
    's2': [0, 0, -1, -1],
    's3': [1, -1, 0, 0],
    's4': [0, 0, 1, -1]
}

# 3. Visualization with expanded Y-axis range
fig, axes = plt.subplots(4, 1, figsize=(10, 16), sharex=True)
colors = ['tab:blue', 'tab:orange', 'tab:green', 'tab:red']

LABEL_FONT = 22
TICK_FONT = 16

for i, (name, vec) in enumerate(s_vectors.items()):
    ax = axes[i]
    signal_t = generate_signal_from_vector(vec, A, Ts, t)
    
    ax.plot(t, signal_t, color=colors[i], lw=3, zorder=3)
    ax.axhline(0, color='black', lw=1.2, zorder=1)
    
    # Drawing reference lines for the peak to show it aligns perfectly
    ax.axhline(peak, color='gray', linestyle='--', lw=0.8, alpha=0.6, zorder=2)
    ax.axhline(-peak, color='gray', linestyle='--', lw=0.8, alpha=0.6, zorder=2)
    
    # Y-axis Labeling
    ax.set_ylabel(fr'${name}(t)$', fontsize=LABEL_FONT, rotation=0, labelpad=50)
    ax.set_yticks([-peak, 0, peak])
    ax.set_yticklabels([r'$-A\sqrt{2}$', '0', r'$A\sqrt{2}$'], fontsize=TICK_FONT)
    
    # --- The Fix: Increasing the range ---
    # Setting the limit to double the peak (2 * peak) to provide enough vertical space
    ax.set_ylim(-peak * 2, peak * 2)
    
    ax.grid(True, axis='x', linestyle=':', alpha=0.4)
    ax.margins(x=0)

# 4. Global X-axis formatting
plt.xticks([0, Ts/4, Ts/2, 3*Ts/4, Ts], 
           ['0', r'$\frac{T_s}{4}$', r'$\frac{T_s}{2}$', r'$\frac{3}{4}T_s$', r'$T_s$'], 
           fontsize=TICK_FONT)
plt.xlabel('t', fontsize=LABEL_FONT, loc='right')
plt.suptitle(r'Time-Domain Signals $s_n(t)$', fontsize=24)

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()