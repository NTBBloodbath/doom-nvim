return function()
	-- Snippets support
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport =
		true


	-- Lsp Symbols
	Fn.sign_define('LspDiagnosticsSignError', {
		texthl = 'LspDiagnosticsSignError',
		text = Doom.lsp_error,
		numhl = 'LspDiagnosticsSignError',
	})
	Fn.sign_define('LspDiagnosticsSignWarning', {
		texthl = 'LspDiagnosticsSignWarning',
		text = Doom.lsp_warning,
		numhl = 'LspDiagnosticsSignWarning',
	})
	Fn.sign_define('LspDiagnosticsSignHint', {
		texthl = 'LspDiagnosticsSignHint',
		text = Doom.lsp_hint,
		numhl = 'LspDiagnosticsSignHint',
	})
	Fn.sign_define('LspDiagnosticsSignInformation', {
		texthl = 'LspDiagnosticsSignInformation',
		text = Doom.lsp_information,
		numhl = 'LspDiagnosticsSignInformation',
	})

	vim.lsp.handlers['textDocument/publishDiagnostics'] =
		vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = {
				prefix = Doom.lsp_virtual_text, -- change this to whatever you want your diagnostic icons to be
			},
		})

end