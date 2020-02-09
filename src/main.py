#!/usr/bin/env python3

import os
import typer
import jinja2
from typer import secho
from typing import List
from pathlib import Path
from packaging import version
from dataclasses import dataclass
from collections import namedtuple

app = typer.Typer(add_completion=False, help='')
SRC_PATH = Path(__file__).parent
FORMULA_PATH = Path(__file__).parent.parent / 'Formula'
WOREFLOW_PATH = Path(__file__).parent.parent / '.github/workflows'


@dataclass
class FormulaContext:
    version: str
    tag: str = ""

    test_version: str = ""
    test_retcode: int = 0

    file_version: str = ""
    class_version: str = ""

    with_autotools: bool = False
    with_cmake: bool = False

    bins: List[str] = None

    def __post_init__(self):
        if not self.tag:
            self.tag = self.version
        if not self.file_version:
            self.file_version = self.version
        if not self.test_version:
            self.test_version = self.tag.removeprefix('v')
        if not self.class_version:
            self.class_version = self.file_version.replace('.', '')

    @staticmethod
    def makeFromVersions(versions: List[str]):
        return [FormulaContext(ver) for ver in versions]


@dataclass(init=True)
class LlvmContext(FormulaContext):
    extra_resource: bool = False
    use_old_registry: bool = False

    def __post_init__(self):
        super().__post_init__()
        if version.parse(self.tag) <= version.parse('8.0.1'):
            self.extra_resource = True
        if version.parse(self.tag) <= version.parse('6.0.1'):
            self.use_old_registry = True

    @staticmethod
    def makeFromVersions(versions: List[str]):
        return [LlvmContext(ver) for ver in versions]


@dataclass(init=True)
class ThriftContext(FormulaContext):

    def __post_init__(self):
        super().__post_init__()
        self.with_cmake = True
        if version.parse(self.version) <= version.parse('0.9.2'):
            self.with_cmake = False
            self.with_autotools = True
        if version.parse(self.version) <= version.parse('0.9.1'):
            self.test_retcode = 1

    @staticmethod
    def makeFromVersions(versions: List[str]):
        return [ThriftContext(ver) for ver in versions]


def link_formula():
    template_env = jinja2.Environment(
        trim_blocks=True,
        lstrip_blocks=True,
        loader=jinja2.FileSystemLoader(SRC_PATH),
    )

    action_template = template_env.get_template(f'template/action.yaml.j2')

    for f in SRC_PATH.glob('**/*.rb'):
        if 'archived' not in f.as_posix():
            target = FORMULA_PATH / f.name
            target.unlink(True)
            os.symlink(os.path.relpath(f, target)[3:], target)

            action_output = WOREFLOW_PATH / f'build-{f.name[:-3]}.yaml'
            action_output.write_text(action_template.render(name=f.name[:-3]))


def generate_formula():
    Config = namedtuple('Config', ['name', 'bins', 'ctxs'])
    configs = [
        Config(name='fbthriftc',
               bins=['thrift1'],
               ctxs=FormulaContext.makeFromVersions(
                   ['2019.06.03', '2019.12.30', '2020.12.14', '2021.03.01'])),
        Config(name='llvm-tools',
               bins=['clang-format', 'clang-query', 'clang-tidy'],
               ctxs=LlvmContext.makeFromVersions([
                   '3.9.1', '4.0.1', '5.0.2', '6.0.1', '7.1.0', '8.0.1', '9.0.1', '10.0.1', '11.0.0'
               ])),
        Config(name='protoc',
               bins=['protoc'],
               ctxs=FormulaContext.makeFromVersions([
                   '3.1.0', '3.2.0', '3.3.2', '3.4.1', '3.5.2', '3.7.1', '3.8.0', '3.9.2',
                   '3.13.0.1', '3.14.0', '3.15.6'
               ])),
        Config(name='thriftc',
               bins=['thrift'],
               ctxs=ThriftContext.makeFromVersions([
                   '0.8.0', '0.9.0', '0.9.1', '0.9.2', '0.9.3', '0.9.3.1', '0.10.0', '0.11.0',
                   '0.12.0', '0.13.0', '0.14.1'
               ])),
        Config(name='xz',
               bins=['xz'],
               ctxs=FormulaContext.makeFromVersions([
                   '5.2.5', '5.2.4', '5.2.3', '5.2.2', '5.2.1', '5.2.0', '5.0.8', '5.0.7', '5.0.6',
                   '5.0.5', '5.0.4', '5.0.3', '5.0.2', '5.0.1', '5.0.0'
               ])),
        Config(name='tmux',
               bins=['tmux'],
               ctxs=FormulaContext.makeFromVersions(
                   ['3.1c', '3.0a', '2.9a', '2.8', '2.7', '2.6', '2.5'])),
    ]

    template_env = jinja2.Environment(
        trim_blocks=True,
        lstrip_blocks=True,
        loader=jinja2.FileSystemLoader(SRC_PATH),
    )

    action_template = template_env.get_template(f'template/action-binary.yaml.j2')
    for config in configs:
        template = template_env.get_template(f'formula/{config.name}/{config.name}.rb.j2')
        for ctx in config.ctxs:
            ctx.bins = config.bins
            output = FORMULA_PATH / f"{config.name}@{ctx.version}.rb"
            output.write_text(template.render(ctx=ctx))

        action_output = WOREFLOW_PATH / f'build-{config.name}.yaml'
        action_output.write_text(
            action_template.render(name=config.name,
                                   bins=config.bins,
                                   versions=[c.version for c in config.ctxs]))


@app.command()
def main():
    link_formula()
    generate_formula()


if __name__ == "__main__":
    app()
