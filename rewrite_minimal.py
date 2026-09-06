html = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConstraintForge</title>
    <style>
        :root {
            --bg-base: #09090b;
            --bg-panel: #121214;
            --text-main: #ededef;
            --text-muted: #a1a1aa;
            --accent: #ef4444;
            --border: #27272a;
            --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            --font-mono: "JetBrains Mono", "Fira Code", "SFMono-Regular", Consolas, monospace;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; scroll-behavior: smooth; }

        body {
            font-family: var(--font-sans);
            background-color: var(--bg-base);
            color: var(--text-main);
            display: flex;
            min-height: 100vh;
            line-height: 1.6;
        }

        /* Sidebar */
        aside {
            position: fixed;
            top: 0; left: 0; bottom: 0;
            width: 240px;
            border-right: 1px solid var(--border);
            padding: 40px 0;
            background: var(--bg-base);
        }

        .logo {
            font-weight: 700;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0 24px;
            margin-bottom: 40px;
        }
        
        .logo span {
            color: var(--text-muted);
            font-size: 0.75rem;
            border: 1px solid var(--border);
            padding: 2px 6px;
            border-radius: 4px;
            text-transform: uppercase;
        }

        .nav-group-title {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: var(--text-muted);
            font-weight: 600;
            letter-spacing: 1px;
            padding: 0 24px;
            margin-bottom: 12px;
            margin-top: 24px;
        }

        .nav-item {
            display: block;
            padding: 8px 24px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
            border-left: 2px solid transparent;
        }

        .nav-item:hover { color: var(--text-main); }
        .nav-item.active {
            color: var(--text-main);
            border-left-color: var(--accent);
            background-color: rgba(239, 68, 68, 0.05);
            font-weight: 500;
        }

        /* Main Content */
        main {
            margin-left: 240px;
            padding: 60px 48px;
            max-width: 800px;
            width: 100%;
        }

        section { margin-bottom: 80px; padding-top: 20px; }

        h1 { font-size: 2rem; margin-bottom: 16px; letter-spacing: -0.5px; }
        h2 { font-size: 1.25rem; margin-bottom: 24px; font-weight: 600; border-bottom: 1px solid var(--border); padding-bottom: 8px; }
        p { color: var(--text-muted); margin-bottom: 24px; font-size: 1rem; max-width: 600px; }

        /* Mac Terminal */
        .mac-terminal {
            background-color: #000000;
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .mac-header {
            background-color: #1a1a1a;
            padding: 10px 16px;
            display: flex;
            gap: 8px;
            border-bottom: 1px solid var(--border);
        }

        .mac-dot { width: 12px; height: 12px; border-radius: 50%; }
        .mac-dot.close { background-color: #ff5f56; }
        .mac-dot.minimize { background-color: #ffbd2e; }
        .mac-dot.maximize { background-color: #27c93f; }

        .mac-body {
            padding: 20px;
            font-family: var(--font-mono);
            font-size: 0.85rem;
            line-height: 1.6;
            color: #d4d4d4;
            min-height: 250px;
            overflow-x: auto;
        }

        .prompt { color: #3b82f6; font-weight: 600; }
        .command { color: #ffffff; }
        .output-info { color: #3b82f6; }
        .output-success { color: #22c55e; font-weight: 600; }
        .output-warn { color: #eab308; font-weight: 600; }
        .output-error { color: #ef4444; font-weight: 600; }
        .output-highlight { color: #a855f7; }
        .output-dim { color: #737373; }

        .cursor::after {
            content: "█";
            animation: blink 1s step-start infinite;
            color: #a1a1aa;
            margin-left: 4px;
        }
        @keyframes blink { 50% { opacity: 0; } }
    </style>
</head>
<body>

    <aside>
        <div class="logo">ConstraintForge <span>Docs</span></div>
        <div class="nav-group-title">Overview</div>
        <a href="#introduction" class="nav-item active">Introduction</a>
        <div class="nav-group-title">Setup & Execution</div>
        <a href="#installation" class="nav-item">Installation</a>
        <a href="#execution" class="nav-item">Execution</a>
    </aside>

    <main>
        <section id="introduction">
            <h1>ConstraintForge</h1>
            <p>Structural timing diagnostics in milliseconds. No synthesis, no routing, just deterministic O(|V|+|E|) math.</p>
        </section>

        <section id="installation">
            <h2>Installation</h2>
            <p>Pull the engine and initialize the local environment.</p>
            <div class="mac-terminal">
                <div class="mac-header">
                    <div class="mac-dot close"></div>
                    <div class="mac-dot minimize"></div>
                    <div class="mac-dot maximize"></div>
                </div>
                <div class="mac-body" id="term1-body"></div>
            </div>
        </section>

        <section id="execution">
            <h2>Execution</h2>
            <p>Pass your top module to the engine. Instantly detect setup-time risks, CDC boundaries, and high-fanout routing bottlenecks.</p>
            <div class="mac-terminal">
                <div class="mac-header">
                    <div class="mac-dot close"></div>
                    <div class="mac-dot minimize"></div>
                    <div class="mac-dot maximize"></div>
                </div>
                <div class="mac-body" id="term2-body"></div>
            </div>
        </section>
    </main>

    <script>
        const sections = document.querySelectorAll('section');
        const navItems = document.querySelectorAll('.nav-item');

        function updateSidebar() {
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                if (window.scrollY >= sectionTop - 150) {
                    current = section.getAttribute('id');
                }
            });

            if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 10) {
                current = sections[sections.length - 1].getAttribute('id');
            }

            navItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href') === `#${current}`) {
                    item.classList.add('active');
                }
            });
        }

        window.addEventListener('scroll', updateSidebar);
        updateSidebar();

        async function typeText(element, text, speed = 30) {
            for (let char of text) {
                element.textContent += char;
                await new Promise(r => setTimeout(r, speed + Math.random() * 20));
            }
        }

        async function animateTerminal(elementId, sequence, loopDelay = 5000) {
            const termBody = document.getElementById(elementId);
            
            while (true) {
                termBody.innerHTML = '';
                let currentPrompt = '~/dev $';
                let currentLine = null;
                let commandSpan = null;
                
                if (sequence.length > 0 && sequence[0].type !== 'prompt') {
                    currentLine = document.createElement('div');
                    currentLine.innerHTML = `<span class="prompt">${currentPrompt}</span> <span class="command cursor"></span>`;
                    termBody.appendChild(currentLine);
                    commandSpan = currentLine.querySelector('.command');
                }
                
                for (let step of sequence) {
                    await new Promise(r => setTimeout(r, step.delay));
                    
                    if (step.type === 'input') {
                        if (step.text === '') continue;
                        commandSpan.classList.remove('cursor');
                        await typeText(commandSpan, step.text, step.speed || 30);
                    } else if (step.type === 'output') {
                        let outLine = document.createElement('div');
                        outLine.innerHTML = step.html;
                        termBody.appendChild(outLine);
                    } else if (step.type === 'prompt') {
                        currentPrompt = step.prompt || '~/dev $';
                        currentLine = document.createElement('div');
                        currentLine.innerHTML = `<span class="prompt">${currentPrompt}</span> <span class="command cursor"></span>`;
                        termBody.appendChild(currentLine);
                        commandSpan = currentLine.querySelector('.command');
                    }
                }
                
                if (!currentLine || !currentLine.innerHTML.includes('cursor')) {
                    currentLine = document.createElement('div');
                    currentLine.innerHTML = `<span class="prompt">${currentPrompt}</span> <span class="command cursor"></span>`;
                    termBody.appendChild(currentLine);
                }
                
                await new Promise(r => setTimeout(r, loopDelay));
            }
        }

        const anim1 = [
            { type: 'input', text: 'git clone https://github.com/devtyagi3909/constraintforge.git', delay: 800 },
            { type: 'output', html: "Cloning into 'constraintforge'...", delay: 400 },
            { type: 'output', html: '<span class="output-dim">remote: Enumerating objects: 142, done.</span>', delay: 200 },
            { type: 'output', html: '<span class="output-dim">Receiving objects: 100% (142/142), 2.41 MiB | 5.34 MiB/s, done.</span>', delay: 300 },
            { type: 'prompt', prompt: '~/dev $', delay: 400 },
            { type: 'input', text: 'cd constraintforge', delay: 600 },
            { type: 'prompt', prompt: '~/dev/constraintforge $', delay: 200 },
            { type: 'input', text: 'brew install yosys python3', delay: 800 },
            { type: 'output', html: '<span class="output-info">[INFO]</span> Checking dependencies...', delay: 400 },
            { type: 'output', html: '<span class="output-success">[OK]</span> Found Yosys 0.33', delay: 300 },
            { type: 'output', html: '<span class="output-success">[OK]</span> Found Python 3.11.5', delay: 150 },
            { type: 'output', html: '<span class="output-success">[SUCCESS]</span> Environment ready. ConstraintForge is armed.', delay: 600 },
            { type: 'prompt', prompt: '~/dev/constraintforge $', delay: 200 }
        ];

        const anim2 = [
            { type: 'prompt', prompt: '~/dev/constraintforge $', delay: 500 },
            { type: 'input', text: 'python3 diagnose.py picorv32.v --top picorv32', delay: 1000 },
            { type: 'output', html: '<span class="output-info">[*]</span> Parsing picorv32.v AST via headless Yosys...', delay: 600 },
            { type: 'output', html: '<span class="output-info">[*]</span> Extracting Directed Acyclic Graph (DAG)...', delay: 300 },
            { type: 'output', html: '<span class="output-info">[*]</span> Executing Topological DFS Memoization...', delay: 200 },
            { type: 'output', html: '<br><span class="command">## DIAGNOSTIC REPORT: picorv32.v ##</span><br>', delay: 400 },
            { type: 'output', html: '<span class="output-warn">[WARNING] setup-time risk detected:</span>', delay: 200 },
            { type: 'output', html: '  Source:      cell:$_DFF_P_:Q <span class="output-dim">(picorv32.v:412)</span> [Clk: clk]', delay: 50 },
            { type: 'output', html: '  Sink:        cell:$_DFF_P_:D <span class="output-dim">(picorv32.v:556)</span> [Clk: clk]', delay: 50 },
            { type: 'output', html: '  Logic Depth: <span class="output-warn">33 gates</span><br>', delay: 150 },
            { type: 'output', html: '<span class="output-error">[ALERT] Clock Domain Crossing (CDC) Violation:</span>', delay: 300 },
            { type: 'output', html: '  Data signal <span class="output-highlight">\'rx_data\'</span> crosses from <span class="output-highlight">\'clk_rx\'</span> to <span class="output-highlight">\'clk_sys\'</span> without synchronizer.', delay: 50 },
            { type: 'output', html: '  Path: <span class="output-dim">(picorv32.v:620) -> (picorv32.v:625)</span><br>', delay: 50 },
            { type: 'output', html: '<span class="output-success">[OK]</span> Analysis completed in 14ms.', delay: 400 },
            { type: 'prompt', prompt: '~/dev/constraintforge $', delay: 200 }
        ];

        setTimeout(() => animateTerminal('term1-body', anim1, 6000), 500);
        setTimeout(() => animateTerminal('term2-body', anim2, 8000), 1000);
    </script>
</body>
</html>
"""

with open('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'w') as f:
    f.write(html)
