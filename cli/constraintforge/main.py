import click
import sys
from rich.console import Console
from .yosys_runner import generate_netlist
from .analyzer import build_graph, analyze_logic_depth, analyze_fanout
from .reporter import print_report

console = Console()

@click.group()
def cli():
    pass

@cli.command()
@click.argument('src_files', nargs=-1, required=True)
@click.option('--top', required=True, help="Top level module name")
@click.option('--max-depth', default=20, help="Flag paths exceeding this logic depth")
@click.option('--max-fanout', default=100, help="Flag registers driving more than this many endpoints")
def diagnose(src_files, top, max_depth, max_fanout):
    with console.status(f"[bold cyan]Flattening {top} via Yosys..."):
        json_path = generate_netlist(src_files, top)
        
    if not json_path:
        console.print("[bold red]Yosys failed to parse RTL.[/bold red]")
        sys.exit(1)

    with console.status("[bold cyan]Building AST Adjacency List..."):
        graph = build_graph(json_path)
    
    with console.status("[bold cyan]Running Structural Diagnostics..."):
        critical_paths = analyze_logic_depth(graph, max_depth)
        fanout_nets = analyze_fanout(graph, max_fanout)
        
    print_report(critical_paths, fanout_nets, top, max_depth, max_fanout)

if __name__ == '__main__':
    cli()
