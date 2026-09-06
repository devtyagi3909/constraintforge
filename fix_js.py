import re

with open('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'r') as f:
    html = f.read()

new_script = """<script>
    try {
        const sections = document.querySelectorAll('section');
        const navItems = document.querySelectorAll('.nav-item');

        function updateSidebar() {
            if (sections.length === 0) return;
            let current = '';
            sections.forEach(section => {
                if (window.scrollY >= (section.offsetTop - 150)) {
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
    } catch (e) { console.error(e); }

    async function typeText(element, text, speed = 30) {
        for (let char of text) {
            element.textContent += char;
            await new Promise(r => setTimeout(r, speed + Math.random() * 20));
        }
    }

    async function animateTerminal(elementId, sequence, loopDelay = 5000) {
        try {
            const termBody = document.getElementById(elementId);
            if (!termBody) return;
            
            while (true) {
                termBody.innerHTML = '';
                let currentPrompt = '~/dev $';
                let commandSpan = null;
                
                const createPrompt = (promptText) => {
                    const line = document.createElement('div');
                    line.innerHTML = `<span class="prompt">${promptText}</span> <span class="command cursor"></span>`;
                    termBody.appendChild(line);
                    commandSpan = line.querySelector('.command');
                };
                
                if (sequence.length > 0 && sequence[0].type !== 'prompt') {
                    createPrompt(currentPrompt);
                }
                
                for (let step of sequence) {
                    await new Promise(r => setTimeout(r, step.delay));
                    
                    if (step.type === 'input') {
                        if (!commandSpan) createPrompt(currentPrompt);
                        commandSpan.classList.remove('cursor');
                        await typeText(commandSpan, step.text, step.speed || 30);
                    } else if (step.type === 'output') {
                        const outLine = document.createElement('div');
                        outLine.innerHTML = step.html;
                        termBody.appendChild(outLine);
                    } else if (step.type === 'prompt') {
                        if (commandSpan) commandSpan.classList.remove('cursor');
                        currentPrompt = step.prompt || '~/dev $';
                        createPrompt(currentPrompt);
                    }
                }
                
                await new Promise(r => setTimeout(r, loopDelay));
            }
        } catch (e) { console.error(e); }
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
        { type: 'output', html: '  Data signal <span class="output-highlight">\\\'rx_data\\\'</span> crosses from <span class="output-highlight">\\\'clk_rx\\\'</span> to <span class="output-highlight">\\\'clk_sys\\\'</span> without synchronizer.', delay: 50 },
        { type: 'output', html: '  Path: <span class="output-dim">(picorv32.v:620) -> (picorv32.v:625)</span><br>', delay: 50 },
        { type: 'output', html: '<span class="output-success">[OK]</span> Analysis completed in 14ms.', delay: 400 },
        { type: 'prompt', prompt: '~/dev/constraintforge $', delay: 200 }
    ];

    setTimeout(() => animateTerminal('term1-body', anim1, 6000), 500);
    setTimeout(() => animateTerminal('term2-body', anim2, 8000), 1000);
</script>"""

html = re.sub(r'<script>.*?</script>', new_script, html, flags=re.DOTALL)

with open('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'w') as f:
    f.write(html)
