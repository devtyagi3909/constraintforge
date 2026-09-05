from rich.console import Console
from rich.table import Table

console = Console()

def print_report(paths, fanouts, top, max_depth, max_fanout):
    console.print(f"\n[bold cyan]CONSTRAINTFORGE // TIMING DIAGNOSTICS FOR '{top}'[/bold cyan]\n")
    
    # Depth Report
    if not paths:
        console.print(f"[bold green]✔ Zero paths exceed {max_depth} logic levels.[/bold green]\n")
    else:
        console.print(f"[bold red]❌ CRITICAL:[/bold red] Found {len(paths)} paths exceeding {max_depth} logic levels\n")
        table = Table(show_header=True, header_style="bold magenta")
        table.add_column("Logic Depth")
        table.add_column("Source Register (File:Line)")
        table.add_column("Sink Register (File:Line)")
        
        for p in paths:
            table.add_row(str(p['depth']), p['source'], p['sink'])
            
        console.print(table)
        console.print("[dim]Diagnosis: Deep combinational clouds cause setup time violations. Pipeline the logic between these lines.[/dim]\n")

    # Fanout Report
    if not fanouts:
        console.print(f"[bold green]✔ Zero registers exceed {max_fanout} fanout endpoints.[/bold green]\n")
    else:
        console.print(f"[bold yellow]⚠ WARNING:[/bold yellow] Found {len(fanouts)} high-fanout registers\n")
        table = Table(show_header=True, header_style="bold yellow")
        table.add_column("Fanout Endpoints")
        table.add_column("Source Register (File:Line)")
        
        for f in fanouts:
            table.add_row(str(f['fanout']), f['register'])
            
        console.print(table)
        console.print("[dim]Diagnosis: High fanout causes severe routing delay. Consider register replication (duplication) or BUFG promotion.[/dim]\n")
