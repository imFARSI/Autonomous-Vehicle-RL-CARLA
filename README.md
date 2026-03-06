# Autonomous Vehicle RL — DDPG on CARLA

Deep Reinforcement Learning agent for self-driving vehicles using DDPG (Deep Deterministic Policy Gradient) and the CARLA 0.9.10 simulator.

---

## 1. Technologies & Environment

| Component | Details |
|-----------|---------|
| **Simulator** | CARLA 0.9.10 (UE4-based) |
| **Language** | Python 3.7.9 |
| **Framework** | TensorFlow 2.11.0 + Keras (`compat.v1`) |
| **Algorithm** | DDPG — Actor-Critic for continuous action spaces |

---

## 2. How It Works

The agent uses **DDPG** — an actor-critic algorithm for continuous control (steering + throttle).

### Neural Networks
- **Actor:** Takes the current state (waypoints + velocity) and outputs steering & throttle
- **Critic:** Evaluates how good the actor's actions were

### State Input
- **Local Waypoints** — relative path coordinates ahead of the car
- **Kinematics** — current velocity and heading angle

### Reward System
| Event | Reward |
|-------|--------|
| Driving fast & aligned with road | `+ Velocity × Alignment` |
| Drifting from lane center | `− Centrality penalty` |
| Collision | **−200** (episode ends) |
| Lane departure | **−200** (episode ends) |
| Reaching destination | **+100** |

### Learning Process
1. Car explores by driving (randomly at first)
2. Each experience `(state, action, reward)` is stored in a **Replay Buffer**
3. Random batches are sampled to train the networks
4. **Target networks** update slowly for stable learning
5. Over **8,000 episodes**, the car learns smoother, safer driving

---

## 3. Project Structure

```
Thesis first demo/
├── rl_agent_09/             ← Main agent code
│   ├── DDPG/
│   │   ├── ddpg_carla.py    ← Main training/demo loop
│   │   ├── actor.py         ← Actor network
│   │   ├── critic.py        ← Critic network
│   │   ├── carla_env.py     ← CARLA environment wrapper
│   │   └── replay_buffer.py ← Experience replay
│   ├── carla_config.py      ← All hyperparameters & settings
│   ├── data/
│   │   └── data_WAYPOINTS_CARLA/  ← Saved weights (.h5)
│   └── logs/
│       └── logs_WAYPOINTS_CARLA/  ← TensorBoard logs
├── scripts/
│   ├── start_carla.bat      ← Step 1: Launch CARLA simulator
│   ├── train.bat            ← Step 2A: Train the agent
│   ├── demo.bat             ← Step 2B: Run on trained weights
│   ├── check_progress.bat   ← Check training progress anytime
│   └── run_all.bat          ← Launch CARLA + training together
└── README.md
```

---

## 4. How to Use

### Prerequisites
- CARLA 0.9.10 simulator installed (run `scripts\extract_carla.bat` if needed)
- Python 3.7 virtual environment set up (run `scripts\setup_python37.bat` if needed)

---

### 🚀 Step 1 — Start the Simulator
Open a terminal and run:
```powershell
scripts\start_carla.bat
```
Wait until the CARLA window appears and the map (Town01) finishes loading (~30 seconds).

---

### 🎓 Step 2A — Training Mode

Open a **second terminal** and run:
```powershell
scripts\train.bat
```

**What happens:**
- The car starts driving and learning from scratch (or resumes from last checkpoint)
- Weights are **auto-saved every 3 episodes** to `rl_agent_09/data/data_WAYPOINTS_CARLA/`
- Also saves milestone weights every **50 episodes** (`RANDOM_50_actor.h5`, `RANDOM_100_actor.h5`, ...)
- Saves **best reward weights** whenever a new high score is achieved
- Runs for up to **8,000 episodes** total

**When is training done?**
- ✅ `average_reward` graph in TensorBoard flattens/plateaus
- ✅ The car drives smoothly with few crashes in demo mode
- ✅ `RANDOM_best_reward_actor.h5` exists and reward is no longer improving

> ⏱️ Expect ~1–3 min per episode early on. Meaningful behavior typically emerges after ~500 episodes (~8–24 hours).

---

### 🎬 Step 2B — Demo Mode (Run on Trained Weights)

Open a **second terminal** and run:
```powershell
scripts\demo.bat
```

**What happens:**
- Loads the single latest saved weights file (`RANDOM_actor.h5`) from `rl_agent_09/data/data_WAYPOINTS_CARLA/`
- Car drives using **all the knowledge accumulated across all your past training sessions combined**
- No new learning occurs — purely for demonstration
- As you do more training sessions over time, this demo automatically becomes smoother and smarter!

> ⚠️ Demo mode requires trained weights (`RANDOM_actor.h5`) to exist first. If no weights are saved yet, the car will drive randomly.

---

### 📊 Step 3 — Check Training Progress (Anytime)

**Option A — Quick file check:**
```powershell
scripts\check_progress.bat
```
Shows: which weight files are saved, when they were last updated, and training status summary.

**Option B — TensorBoard graphs:**
Open a third terminal and run:
```powershell
.\venv37\Scripts\python.exe -m tensorboard.main --logdir=rl_agent_09/logs
```
Then open: **http://localhost:6006**

You'll see live graphs for:
- `average_reward` — should trend upward
- `max_reward` — best episode reward so far
- `distance` — average distance driven per episode

---

## 5. Saved Weights Explained

**Location:** `rl_agent_09/data/data_WAYPOINTS_CARLA/`

| File | Description |
|------|-------------|
| `RANDOM_actor.h5` | Latest actor weights (updated every 3 eps) |
| `RANDOM_critic.h5` | Latest critic weights (updated every 3 eps) |
| `RANDOM_50_actor.h5` | Milestone checkpoint at episode 50 |
| `RANDOM_100_actor.h5` | Milestone checkpoint at episode 100 |
| `RANDOM_best_reward_actor.h5` | **Best performing weights ever** |

> 💡 For demos and thesis presentation, use `RANDOM_best_reward_actor.h5` — it represents the agent's peak performance.

---

## 6. Hyperparameters (carla_config.py)

| Parameter | Value | Meaning |
|-----------|-------|---------|
| `episodes_num` | 8,000 | Total training episodes |
| `max_steps` | 100,000 | Max steps per episode |
| `batch_size` | 32 | Samples per training update |
| `gamma` | 0.99 | Future reward discount |
| `tau` | 0.001 | Target network update rate |
| `lra` | 0.0001 | Actor learning rate |
| `lrc` | 0.001 | Critic learning rate |
| `buffer_size` | 100,000 | Replay buffer capacity |

---

## 7. Cumulative Training Workflow

Your training process is **100% cumulative**. You do *not* need to train 8,000 episodes all at once!

1. **Train when you have time:** Run `train.bat` for an hour, then stop it.
2. **It remembers:** The agent saves everything it learned into `RANDOM_actor.h5`.
3. **Resume later:** Next time you run `train.bat`, it loads `RANDOM_actor.h5` and continues learning strictly from where it left off.
4. **Demo updates automatically:** Whenever you run `demo.bat`, it uses that same `RANDOM_actor.h5` file, meaning the demo is automatically infused with all your cumulative training history.
